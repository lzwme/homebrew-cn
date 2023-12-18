cask "wezterm-nightly" do
  version :latest
  sha256 :no_check

  url "https:github.comwezweztermreleasesdownloadnightlyWezTerm-macos-nightly.zip",
      verified: "github.comwezwezterm"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https:wezfurlong.orgwezterm"

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

  preflight do
    # Move "WezTerm-macos-#{version}WezTerm.app" out of the subfolder
    staged_subfolder = staged_path.glob(["WezTerm-*", "wezterm-*"]).first
    if staged_subfolder
      FileUtils.mv(staged_subfolder"WezTerm.app", staged_path)
      FileUtils.rm_rf(staged_subfolder)
    end
  end

  zap trash: "~LibrarySaved Application Statecom.github.wez.wezterm.savedState"
end