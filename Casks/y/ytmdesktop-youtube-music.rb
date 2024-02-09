cask "ytmdesktop-youtube-music" do
  arch arm: "arm64", intel: "x64"

  version "2.0.0"
  sha256 arm:   "c7a7734d295eaa3a8a7d42db2c2013618fd3fc06e9600d1c1485e1eec153b0cd",
         intel: "8be61191307a1609adfac81fec6d440f17a0f81f1b94b618ef37332262a8d8c8"

  url "https:github.comytmdesktopytmdesktopreleasesdownloadv#{version}YouTube-Music-Desktop-App-darwin-#{arch}-#{version}.zip",
      verified: "github.comytmdesktop"
  name "YouTube Music Desktop App"
  desc "YouTube music client"
  homepage "https:ytmdesktop.app"

  depends_on macos: ">= :catalina"

  app "YouTube Music Desktop App.app"

  zap trash: [
    "~LibraryPreferencesapp.ytmd.plist",
    "~LibrarySaved Application Stateapp.ytmd.savedState",
  ]
end