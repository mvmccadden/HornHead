{ self, inputs, ... }: {
  flake.nixosModules.neovim = { pkgs, lib, ... }: {
    imports = [ inputs.nvf.nixosModules.default ];

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          options = {
            mouse = "a";
            tabstop = 2;
            shiftwidth = 2;
            softtabstop = 2;
            expandtab = true;
            wrap = false;
            smartcase = true;
            ignorecase = true;

            autoindent = true;
            smartindent = true;
            cindent = true;
            cinoptions = ":0,(0,u0,W4,g0,N-s,E-s";

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
          autopairs.nvim-autopairs.enable = true;
          telescope.enable = true;

          treesitter = {
            enable = true;
            grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              doxygen
              c
              cpp
              nix
            ];
          };

          git.gitsigns = {
            enable = true;
            codeActions.enable = true;
            setupOpts = {
              signs = {
                add          = { text = "▎"; };
                change       = { text = "▎"; };
                delete       = { text = ""; };
                topdelete    = { text = ""; };
                changedelete = { text = "▎"; };
                untracked    = { text = "┆"; };
              };
            };
          };

          visuals.nvim-web-devicons.enable = true;

          notify.nvim-notify = {
            enable = true;
            setupOpts = {
              background_colour = "#000000";
            };
          };

          ui.noice = {
            enable = true;
            setupOpts = {
              lsp.signature.auto_open.enable = false;
              presets = {
                command_palette = true;
              };
              routes = [{
                view = "cmdline_popup";
                filter = { event = "msg_showmode"; find = "recording"; };
              }];
            };
          };

          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              window = {
                position = "left";
                width = 30;
              };
              filesystem = {
                filtered_items = {
                  visible = true;
                  hide_dotfiles = false;
                  hide_gitignore = false;
                  hide_hidden = false;
                };
              };
              default_component_config = {
                icon = {
                  folder_closed = "";
                  folder_open = "";
                  folder_empty = "󰜌";
                  default = "󰈚";
                  highlight = "NeoTreeFileIcon";
                };
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

          languages = {
            enableTreesitter = true;

            clang = {
              enable = true;
              lsp.enable = true;
            };

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

          lsp = {
            enable = true;
            lspSignature.enable = true;
            trouble.enable = true;

            lspconfig.sources.nil_ls = ''
              local lspconfig = require('lspconfig')
              lspconfig.nil_ls.setup({
                settings = {
                  ['nil'] = {
                    nix = {
                      autoArchive = false,
                    },
                  },
                },
              })
            '';
          };

          autocomplete.nvim-cmp = {
            enable = true;
            mappings = {
              confirm = "<Tab>";
              next = "<C-n>";
              previous = "<C-p>";
            };
          };

          theme = {
            enable = true;
            name = "rose-pine";
            style = "moon";
            transparent = true;
          };

          luaConfigRC.post = ''
            -- Auto-generate .clang-format in project root if missing
            vim.api.nvim_create_autocmd("FileType", {
              pattern = { "c", "cpp" },
              callback = function()
                local root = vim.fn.getcwd()
                local format_file = root .. "/.clang-format"
                
                if vim.fn.filereadable(format_file) == 0 then
                  local content = [[
                    BasedOnStyle: LLVM
                    BreakBeforeBraces: Allman
                    IndentWidth: 2
                    ColumnLimit: 80

                    # Template Line Breaking
                    BreakTemplateDeclarations: Yes

                    # Namespace Indentation Settings
                    NamespaceIndentation: All
                    FixNamespaceComments: true

                    # Class/Object Indentation Settings
                    AccessModifierOffset: -2
                    IndentAccessModifiers: false

                    # General Alignment
                    IndentCaseLabels: true
                  ]]
                  local file = io.open(format_file, "w")
                  if file then
                    file:write(content)
                    file:close()
                    vim.notify("Created missing .clang-format in " .. root, vim.log.levels.INFO)
                  end
                end
              end,
            })

            vim.diagnostic.config({
              virtual_text = true,
              signs = true,
              underline = true,
              update_in_insert = true,
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
            
            -- Standard LSP format trigger
            vim.keymap.set("n", "<leader>cf", function()
              vim.lsp.buf.format()
            end, { desc = "[C]ode [F]ormat" })
          '';

          keymaps = [
            { key = "<Esc>"; mode = "n"; action = ":nohlsearch<CR>"; desc = "Clear search highlight"; }
            { key = "<C-e>"; mode = "n"; action = ":Neotree toggle<CR>"; desc = "Toggle Neo-Tr[e]e"; }
            { key = "<C-h>"; mode = "n"; action = "<C-w><C-h>"; }
            { key = "<C-l>"; mode = "n"; action = "<C-w><C-l>"; }
            { key = "<C-j>"; mode = "n"; action = "<C-w><C-j>"; }
            { key = "<C-k>"; mode = "n"; action = "<C-w><C-k>"; }
            { key = "<C-H>"; mode = "n"; action = "<C-w><C-H>"; }
            { key = "<C-L>"; mode = "n"; action = "<C-w><C-L>"; }
            { key = "<C-J>"; mode = "n"; action = "<C-w><C-J>"; }
            { key = "<C-K>"; mode = "n"; action = "<C-w><C-K>"; }
          ];
        };
      };
    };
  };
}
