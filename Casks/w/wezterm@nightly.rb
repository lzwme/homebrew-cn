cask "wezterm@nightly" do
  version :latest
  sha256 :no_check

  url "https:github.comweztermweztermreleasesdownloadnightlyWezTerm-macos-nightly.zip",
      verified: "github.comweztermwezterm"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https:wezterm.org"

  conflicts_with cask: "wezterm"

  app "WezTerm.app"
  %w[
    wezterm
    wezterm-gui
    wezterm-mux-server
    strip-ansi-escapes
  ].each do |tool|
    binary "#{appdir}WezTerm.appContentsMacOS#{tool}"
  end

  binary "#{appdir}WezTerm.appContentsResourcesshell-completionzsh",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_wezterm"
  binary "#{appdir}WezTerm.appContentsResourcesshell-completionbash",
         target: "#{HOMEBREW_PREFIX}etcbash_completion.dwezterm"
  binary "#{appdir}WezTerm.appContentsResourcesshell-completionfish",
         target: "#{HOMEBREW_PREFIX}sharefishvendor_completions.dwezterm.fish"

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