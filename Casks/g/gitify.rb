cask "gitify" do
  version "4.5.1"
  sha256 "a5272194e4d32894867783d53e9954be7c1fc177dbe31d140add0ffb427a6b6a"

  url "https:github.comgitify-appgitifyreleasesdownloadv#{version}Gitify-#{version}-universal-mac.zip"
  name "Gitify"
  desc "App that shows GitHub notifications on the desktop"
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