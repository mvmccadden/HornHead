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

          binds.whichKey.enable = true;
    
          # Plugins
          telescope.enable = true;
          treesitter.enable = true;

          git.gitsigns = {
            enable = true;
            codeActions.enable = true;
            setupOpts = {
              signs = {
                add          = { text = "▎"; }; # A clean vertical bar
                change       = { text = "▎"; };
                delete       = { text = ""; }; # A small arrow pointing right
                topdelete    = { text = ""; };
                changedelete = { text = "▎"; };
                untracked    = { text = "┆"; }; # Dotted line for new files
              };
            };
          };

          visuals.nvim-web-devicons.enable = true;
          ui.noice.enable = true;

          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              window = {
                position = "left";
                width = 30;
              };
              default_component_config = {
                icon = {
                  folder_closed = "";
                  folder_open = "";
                  folder_empty = "󰜌";
                  default = "󰈚";
                  highlight = "NeoTreeFileIcon";
                };
                # Git status icons
                git_status = {
                  symbols = {
                    added     = "✚";
                    modified  = "";
                    deleted   = "✖";
                    renamed   = "󰁯";
                    untracked = "";
                    ignored   = "";
                    unstaged  = "󰄱";
                    staged    = "";
                    conflict  = "";
                  };
                };
              };
            };
          };

          terminal.toggleterm = {
            enable = true;
            setupOpts = {
              direction = "horizontal";
              size = 15;
              open_mapping = "[[<c-t>]]";
            };
          };

          # LSP
          lsp = {
            enable = true;
            # Is annoying
            #lightbulb.enable = true;
            lspSignature.enable = true;
            trouble.enable = true;
          };

          languages = {
            enableTreesitter = true;

            clang.enable = true;
            rust.enable = true;
            go.enable = true;

            python.enable = true;
            typescript.enable = true;
            lua.enable = true;
            css.enable = true;

            nix.enable = true;
            markdown.enable = true;
            cmake.enable = true;
            html.enable = true;
          };

          autocomplete.nvim-cmp.enable = true;

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
              key = "<C-r>"; 
              mode = "n"; 
              action = ":Neotree toggle<CR>"; 
              desc = "Toggle Neo-T[r]ee";
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
            {
              key = "<C-H>";
              mode = "n";
              action = "<C-w><C-H>";
            }
            {
              key = "<C-L>";
              mode = "n";
              action = "<C-w><C-L>";
            }
            {
              key = "<C-J>";
              mode = "n";
              action = "<C-w><C-J>";
            }
            {
              key = "<C-K>";
              mode = "n";
              action = "<C-w><C-K>";
            }
          ];
        };
      };
    };
  };
}
