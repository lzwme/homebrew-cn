cask "launchrocket" do
  version "0.7"
  sha256 "51dc78902fecfb7ec26ab5c6516b84d1c62692349864ef48aca2fde81bd2ef4a"

  url "https:github.comjimbojsblaunchrocketreleasesdownloadv#{version}LaunchRocket.prefPane.zip"
  name "LaunchRocket"
  desc "Preference pane to manage Homebrew-installed services"
  homepage "https:github.comjimbojsblaunchrocket"

  deprecate! date: "2023-12-17", because: :discontinued

  prefpane "LaunchRocket.prefPane"

  zap trash: "~LibraryPreferencescom.joshbutts.launchrocket.plist"
end