cask "michaelvillar-timer" do
  version "1.6.0"
  sha256 "b953dcc5e8b942f4e2fb0a64e4732c55ba876ad4f1514769df6dc0cd3f225199"

  url "https:github.commichaelvillartimer-appreleasesdownload#{version}Timer.app.zip"
  name "Timer"
  desc "Timer application"
  homepage "https:github.commichaelvillartimer-app"

  app "Timer.app"

  uninstall quit: "com.michaelvillar.Timer"

  zap trash: [
    "~LibraryPreferencescom.michaelvillar.Timer.plist",
    "~LibrarySaved Application Statecom.michaelvillar.Timer.savedState",
  ]
end