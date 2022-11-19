return require("packer").startup({
    function(use)

        use('wbthomason/packer.nvim')
        use('tomasiser/vim-code-dark')

        -- dpr created lodash of neovim
        use("nvim-lua/plenary.nvim")
        use("nvim-lua/popup.nvim")
        use("nvim-telescope/telescope.nvim")
        use("kyazdani42/nvim-web-devicons")

        -- Primeagen doesn"t create lodash
        use("ThePrimeagen/git-worktree.nvim")
        use("ThePrimeagen/harpoon")

        --lsp
        use("williamboman/mason.nvim")
        use("williamboman/mason-lspconfig.nvim")
        use('neovim/nvim-lspconfig')
        use("nvim-lua/lsp_extensions.nvim")
        use("onsails/lspkind-nvim")
        use("glepnir/lspsaga.nvim")
        use("simrat39/symbols-outline.nvim")
        use("L3MON4D3/LuaSnip")
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-buffer")
        use("f3fora/cmp-spell")
        use("lukas-reineke/cmp-rg")
        use("hrsh7th/nvim-cmp")
        use("saadparwaiz1/cmp_luasnip")
        --treesitter
        use("nvim-treesitter/nvim-treesitter", {
            run = ":TSUpdate"
        })
        use("nvim-treesitter/playground")
        use("romgrk/nvim-treesitter-context")
        use('nvim-treesitter/nvim-treesitter-textobjects')
        --git
        use('airblade/vim-gitgutter')
        use('APZelos/blamer.nvim')
        use('tpope/vim-fugitive')
        --firenvim
        use {
            'glacambre/firenvim',
            run = function() vim.fn['firenvim#install'](0) end
        }

        -- use("~/code/dura.nvim")
        --
        use('szw/vim-maximizer')
        use('chrisbra/changesPlugin')
        use('folke/trouble.nvim')
        --comment
        use('numToStr/Comment.nvim')
        use('JoosepAlviste/nvim-ts-context-commentstring')
        --
        use('kylechui/nvim-surround')
        --use('kana/vim-textobj-user')
        --use('kana/vim-textobj-line')
        --use('kana/vim-textobj-indent')
        --use('kana/vim-textobj-entire')
        --use('beloglazov/vim-textobj-quotes')
        use('vim-scripts/ReplaceWithRegister')
        use('christoomey/vim-system-copy')
        use('tpope/vim-repeat')
        use('tpope/vim-abolish')
        use('editorconfig/editorconfig-vim')
        --arilne
        use('vim-airline/vim-airline')
        --undo tree
        use('mbbill/undotree')
        --terminal
        use("akinsho/toggleterm.nvim")
        use("ray-x/lsp_signature.nvim")
        --nul-ls
        use("jose-elias-alvarez/typescript.nvim")
        use("jose-elias-alvarez/null-ls.nvim")
    end,
    config = {
        git = {
            clone_timeout = false
        }
    }
})
