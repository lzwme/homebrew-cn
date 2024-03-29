cask "gitify" do
  version "5.1.0"
  sha256 "3380e27fea77fc3c6c23e9b5fd796fc9209e5ad57450bd1d3381197f8e136f48"

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