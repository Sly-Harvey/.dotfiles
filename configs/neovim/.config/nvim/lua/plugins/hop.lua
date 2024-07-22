return {
  'phaazon/hop.nvim',
  enabled = true,
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require('hop').setup({
        -- keys = 'etovxqpdygfblzhckisuran', -- bépo layout
    })
  end
}
