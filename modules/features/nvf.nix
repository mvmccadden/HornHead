{ self, inputs, ... }: {
  flake.nixosModules.neovim = {
    imports = [ inputs.nvf.nixosModules.default ];
  
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # options
          options = {
            mouse = "a";
            tabstop = 2;
            shiftwidth = 2;
            softtabstop = 2;
            expandtab = true;
            wrap = false;
            smartcase = true;
            ignorecase = true;
            signcolumn = "yes";
            number = true;
            relativenumber = true;
            textwidth = 80;
            splitright = true;
            splitbelow = true;
            undofile = false;
            swapfile = false;
            writebackup = false;
            updatetime = 200;
            timeoutlen = 1000;
            ttimeoutlen = 10;
            confirm = true;
            clipboard = "unnamedplus";
          };
    
          # Plugins
          telescope.enable = true;
          treesitter.enable = true;
          git.gitsigns = {
            enable = true;
            codeActions.enable = true;
            setupOpts = {
              signs = {
                add = { text = "+"; };
                change = { text = "~"; };
                delete = { text = "_"; };
                topdelete = { text = "-"; };
                changedelete = { text = "\\"; };
              };
            };
          };

          visuals.nvim-web-devicons.enable = true;
          filetree.nvimTree = {
            enable = true;
            openOnSetup = false;
            setupOpts = {
              view = {
                width = 30;
                side = "left";
              };
              # Make sure we can see git files
              filters.git_ignored = false;
              renderer.icons.show.file = true;
            };
          };

          terminal.toggleterm = {
            enable = true;
            setupOpts = {
              direction = "horizontal";
              size = 20;
              open_mapping = "[[<c-t>]]";
            };
          };

          # Themeing
          theme = {
            enable = true;
            name = "rose-pine";
            style = "moon";
            transparent = true;
          };

          # Diagnostics, Autocommands, and Special Keybinds
          luaConfigRC.post = ''
            vim.diagnostic.config({
              virtual_text = true;
              signs = true;
              underline = true;
              update_in_insert = true;
              float = {
                source = "always",
                border = "rounded",
              },
            })

            local signs = { Errors = "x", warn = "!", Hint = "^", Info = "*" }
            for type, icon in pairs(signs) do
              local hl = "DiagnosticSign" .. type
              vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.api.nvim_create_autocmd("TextYankPost", {
              desc = "Highlight when yanking text",
              group = vim.api.nvim_create_augroup("highlight-yank", {clear = true }),
              callback = function()
                vim.highlight.on_yank()
              end,
            })

            vim.keymap.set("n", "<leader>sd", function()
              vim.diagnostic.open_float(0, { scope = "line" })
            end, { desc = "[S]how [D]iagnostic" })

            vim.keymap.set("n", "<leader>sl", function()
              vim.diagnostic.setloclist()
            end, { desc = "[S]how Diagnostic [L]ocation [L]ist" })
          '';
    
          # Keybinds
          keymaps = [
            { 
              key = "<leader>t"; 
              mode = "n"; 
              action = ":NvimTreeToggle<CR>"; 
              desc = "[T]erminal";
            }
            {
              key = "<C-h>";
              mode = "n";
              action = "<C-w><C-h>";
            }
            {
              key = "<C-l>";
              mode = "n";
              action = "<C-w><C-l>";
            }
            {
              key = "<C-j>";
              mode = "n";
              action = "<C-w><C-j>";
            }
            {
              key = "<C-k>";
              mode = "n";
              action = "<C-w><C-k>";
            }
          ];
        };
      };
    };
  };
}
