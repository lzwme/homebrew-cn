cask "wezterm@nightly" do
  version :latest
  sha256 :no_check

  url "https:github.comweztermweztermreleasesdownloadnightlyWezTerm-macos-nightly.zip",
      verified: "github.comweztermwezterm"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https:wezterm.org"

  conflicts_with cask: "wezterm"
  depends_on macos: ">= :sierra"

  app "WezTerm.app"
  %w[
    wezterm
    wezterm-gui
    wezterm-mux-server
    strip-ansi-escapes
  ].each do |tool|
    binary "#{appdir}WezTerm.appContentsMacOS#{tool}"
  end

  bash_completion "#{appdir}WezTerm.appContentsResourcesshell-completionbash", target: "wezterm"
  fish_completion "#{appdir}WezTerm.appContentsResourcesshell-completionfish", target: "wezterm.fish"
  zsh_completion "#{appdir}WezTerm.appContentsResourcesshell-completionzsh", target: "_wezterm"

  preflight do
    # Move "WezTerm-macos-#{version}WezTerm.app" out of the subfolder
    staged_subfolder = staged_path.glob(["WezTerm-*", "wezterm-*"]).first
    if staged_subfolder
      FileUtils.mv(staged_subfolder"WezTerm.app", staged_path)
      FileUtils.rm_r(staged_subfolder)
    end
  end

  zap trash: "~LibrarySaved Application Statecom.github.wez.wezterm.savedState"
end