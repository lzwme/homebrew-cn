cask "google-chat-electron" do
  arch arm: "darwin-arm64", intel: "darwin-x64"

  version "2.20.0"
  sha256 arm:   "ab5a996c01eef382367a3d8f1fef2216dde3ff09cd3169a5d094c715eb49d091",
         intel: "8fc8f51f80a188f3dc851df0958aae12c8648670346980afac8ceab3c05b225d"

  url "https:github.comankurk91google-chat-electronreleasesdownload#{version}google-chat-electron-#{version}-#{arch}.zip"
  name "google-chat-electron"
  desc "Standalone app for Google Chat"
  homepage "https:github.comankurk91google-chat-electron"

  deprecate! date: "2023-12-17", because: :discontinued

  depends_on macos: ">= :catalina"

  app "google-chat-electron.app"

  zap trash: [
    "~LibraryApplication Supportgoogle-chat-electron",
    "~LibraryLaunchAgentsgoogle-chat-electron.plist",
    "~LibraryLogsgoogle-chat-electron",
    "~LibraryPreferencescom.electron.google-chat-electron.plist",
    "~LibrarySaved Application Statecom.electron.google-chat-electron.savedState",
  ]
end