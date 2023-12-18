cask "ytmdesktop-youtube-music" do
  version "1.14.2"
  sha256 "d7fb0b2dbe54469b39fc1c2daf0f17e65b0d84d4a2c171998c41c7691a378f0d"

  url "https:github.comytmdesktopytmdesktopreleasesdownload#{version}ytm-desktop_macos-#{version.tr(".", "_")}.zip",
      verified: "github.comytmdesktop"
  name "YouTube Music Desktop App"
  desc "YouTube music client"
  homepage "https:ytmdesktop.app"

  container nested: "YouTube Music Desktop App-#{version}.dmg"

  app "YouTube Music Desktop App.app"

  zap trash: [
    "~LibraryPreferencesapp.ytmd.plist",
    "~LibrarySaved Application Stateapp.ytmd.savedState",
  ]
end