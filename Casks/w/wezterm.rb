cask "wezterm" do
  version "20240127-113634,bbcac864"
  sha256 "f47bc29ddcd3cb2211084d0da4ed76528b1154f700e2731076d0fc7568f257ea"

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