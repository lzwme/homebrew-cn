cask "ytmdesktop-youtube-music" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "2.0.0"
    sha256 "c7a7734d295eaa3a8a7d42db2c2013618fd3fc06e9600d1c1485e1eec153b0cd"
  end
  on_intel do
    version "2.0.2"
    sha256 "712337e1cc38dadd26162c2380cdcb956f8534c3f3c1b794f799fe935c1054f5"
  end

  url "https:github.comytmdesktopytmdesktopreleasesdownloadv#{version}YouTube-Music-Desktop-App-darwin-#{arch}-#{version}.zip",
      verified: "github.comytmdesktop"
  name "YouTube Music Desktop App"
  desc "YouTube music client"
  homepage "https:ytmdesktop.app"

  disable! date: "2024-03-06", because: :no_longer_available

  depends_on macos: ">= :catalina"

  app "YouTube Music Desktop App.app"

  zap trash: [
    "~LibraryPreferencesapp.ytmd.plist",
    "~LibrarySaved Application Stateapp.ytmd.savedState",
  ]
end