cask "gitify" do
  version "5.4.0"
  sha256 "7f4a92f6dea2ef4ca93b8207da9cf221e28f9331450f58fcff2a73790ebc9a5e"

  url "https:github.comgitify-appgitifyreleasesdownloadv#{version}Gitify-#{version}-universal-mac.zip"
  name "Gitify"
  desc "GitHub Notifications on your menu bar"
  homepage "https:github.comgitify-appgitify"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Gitify.app"

  uninstall quit: [
    "com.electron.gitify",
    "com.electron.gitify.helper",
  ]

  zap trash: [
    "~LibraryApplication Supportgitify",
    "~LibraryPreferencescom.electron.gitify.helper.plist",
    "~LibraryPreferencescom.electron.gitify.plist",
    "~LibrarySaved Application Statecom.electron.gitify.savedState",
  ]
end