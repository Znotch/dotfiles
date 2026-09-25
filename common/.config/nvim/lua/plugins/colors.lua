return {
    {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
	    flavour = "mocha",
	    background = { dark = "mocha", light = "latte"},
	    transparent_background = true,
	       },	

	config = function(_, opts)
	    require("catppuccin").setup(opts)
	    vim.cmd.colorscheme ("catppuccin")
	end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    theme = "catppuccin",
	}
    },
}
