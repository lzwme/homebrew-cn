cask "wezterm" do
  version "20240128-202157,1e552d76"
  sha256 "0cf9e5802a77358ac23f50989bd15b2dffcb3bbf729eb51d69a54edcb1d81fd6"

  url "https:github.comwezweztermreleasesdownload#{version.csv.first}-#{version.csv.second}WezTerm-macos-#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.comwezwezterm"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https:wezfurlong.orgwezterm"

  livecheck do
    url :url
    regex(^(\d+(?:[.-]\d+)+)-(\h+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: "homebrewcask-versionswezterm-nightly"

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