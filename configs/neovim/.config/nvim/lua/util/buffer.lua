local M = {}

local utils = require('util')

M.current_buf, M.last_buf = nil, nil

function M.is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

function M.move(n)
  if n == 0 then return end -- if n = 0 then no shifts are needed
  local bufs = vim.t.bufs -- make temp variable
  for i, bufnr in ipairs(bufs) do -- loop to find current buffer
    if bufnr == vim.api.nvim_get_current_buf() then -- found index of current buffer
      for _ = 0, (n % #bufs) - 1 do -- calculate number of right shifts
        local new_i = i + 1 -- get next i
        if i == #bufs then -- if at end, cycle to beginning
          new_i = 1 -- next i is actually 1 if at the end
          local val = bufs[i] -- save value
          table.remove(bufs, i) -- remove from end
          table.insert(bufs, new_i, val) -- insert at beginning
        else -- if not at the end,then just do an in place swap
          bufs[i], bufs[new_i] = bufs[new_i], bufs[i]
        end
        i = new_i -- iterate i to next value
      end
      break
    end
  end
  vim.t.bufs = bufs -- set buffers
  utils.event "BufsUpdated"
  vim.cmd.redrawtabline() -- redraw tabline
end

function M.nav(n)
  local current = vim.api.nvim_get_current_buf()
  for i, v in ipairs(vim.t.bufs) do
    if current == v then
      vim.cmd.b(vim.t.bufs[(i + n - 1) % #vim.t.bufs + 1])
      break
    end
  end
end

function M.nav_to(tabnr)
  if tabnr > #vim.t.bufs or tabnr < 1 then
    utils.notify(("No tab #%d"):format(tabnr), vim.log.levels.WARN)
  else
    vim.cmd.b(vim.t.bufs[tabnr])
  end
end

function M.prev()
  if vim.fn.bufnr() == M.current_buf then
    if M.last_buf then
      vim.cmd.b(M.last_buf)
    else
      utils.notify("No previous buffer found", vim.log.levels.WARN)
    end
  else
    utils.notify("Must be in a main editor window to switch the window buffer", vim.log.levels.ERROR)
  end
end

function M.close(bufnr, force)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if utils.is_available "mini.bufremove" and M.is_valid(bufnr) and #vim.t.bufs > 1 then
    if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      local bufname = vim.fn.expand "%"
      local empty = bufname == ""
      if empty then bufname = "Untitled" end
      local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
      if confirm == 1 then
        if empty then return end
        vim.cmd.write()
      elseif confirm == 2 then
        force = true
      else
        return
      end
    end
    require("mini.bufremove").delete(bufnr, force)
  else
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    vim.cmd(("silent! %s %d"):format((force or buftype == "terminal") and "bdelete!" or "confirm bdelete", bufnr))
  end
end

function M.close_all(keep_current, force)
  if keep_current == nil then keep_current = false end
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.t.bufs) do
    if not keep_current or bufnr ~= current then M.close(bufnr, force) end
  end
end

function M.close_left(force)
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.t.bufs) do
    if bufnr == current then break end
    M.close(bufnr, force)
  end
end

function M.close_right(force)
  local current = vim.api.nvim_get_current_buf()
  local after_current = false
  for _, bufnr in ipairs(vim.t.bufs) do
    if after_current then M.close(bufnr, force) end
    if bufnr == current then after_current = true end
  end
end

function M.sort(compare_func, skip_autocmd)
  if type(compare_func) == "string" then compare_func = M.comparator[compare_func] end
  if type(compare_func) == "function" then
    local bufs = vim.t.bufs
    table.sort(bufs, compare_func)
    vim.t.bufs = bufs
    if not skip_autocmd then utils.event "BufsUpdated" end
    vim.cmd.redrawtabline()
    return true
  end
  return false
end

function M.close_tab(tabpage)
  if #vim.api.nvim_list_tabpages() > 1 then
    tabpage = tabpage or vim.api.nvim_get_current_tabpage()
    vim.t[tabpage].bufs = nil
    utils.event "BufsUpdated"
    vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tabpage))
  end
end

M.comparator = {}

local function bufinfo(bufnr) return vim.fn.getbufinfo(bufnr)[1] end

function M.comparator.bufnr(bufnr_a, bufnr_b) return bufnr_a < bufnr_b end

function M.comparator.extension(bufnr_a, bufnr_b)
  return vim.fn.fnamemodify(bufinfo(bufnr_a).name, ":e") < vim.fn.fnamemodify(bufinfo(bufnr_b).name, ":e")
end

function M.comparator.full_path(bufnr_a, bufnr_b)
  return vim.fn.fnamemodify(bufinfo(bufnr_a).name, ":p") < vim.fn.fnamemodify(bufinfo(bufnr_b).name, ":p")
end

function M.comparator.modified(bufnr_a, bufnr_b) return bufinfo(bufnr_a).lastused > bufinfo(bufnr_b).lastused end

return M
