cask "gitify" do
  version "5.2.0"
  sha256 "c2bddbacea0c8397ae1c3bb6bebef1a3487dd89d85253f72ef90ae898d40e080"

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