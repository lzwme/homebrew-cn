cask "gitify" do
  version "5.3.0"
  sha256 "2e234cacfbb103d2b3797ac539ee8fa362c234c05b72b231b7a6102037455725"

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