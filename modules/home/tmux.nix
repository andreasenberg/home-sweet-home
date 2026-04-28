{ ... }:
{
  flake.homeModules.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        keyMode = "vi";
        mouse = true;

        prefix = "C-s";

        terminal = "tmux-256color";

        extraConfig = ''
          unbind r
          bind r source-file ~/.config/tmux/tmux.conf

          set -ag terminal-overrides ",xterm-256color:RGB"

          # Adjusting as a way to get rid of latency when switching between modes in Helix
          set -s escape-time 50  # ~5-100 https://superuser.com/a/1809494

          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          # Open new window at current path
          bind c new-window -c "#{pane_current_path}"

          # Status bar
          set-option -g status-position top

          # Splits to use current path
          bind-key v split-window -h -c "#{pane_current_path}"
          bind-key b split-window -c "#{pane_current_path}"

          # Custom rename format to have tmux set the path if a regular shell (fish)
          # If will show the command if something is executed and the custom window name if that is set (handled by #W)
          set -g automatic-rename-format "#{?#{==:#{pane_current_command},fish},#{s|$HOME|~|:pane_current_path},#{pane_current_command}}"
        '';

        plugins = with pkgs; [
          # tmuxPlugins.vim-tmux-navigator
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_window_default_text " #W"
              set -g @catppuccin_window_current_text " #W"
              set -g @catppuccin_window_text " #W"
              set -g @catppuccin_window_status_style "rounded"

              set -g status-left ""
              set -g status-right "#{E:@catppuccin_status_application} #{E:@catppuccin_status_session}"
            '';
          }
        ];
      };
    };
}
