cask "gitify" do
  version "5.12.1"
  sha256 "548b0b3d60568da4c7d789b73b20e138540ebbdb098b6077bdf5d01e359167b3"

  url "https:github.comgitify-appgitifyreleasesdownloadv#{version}Gitify-#{version}-universal-mac.zip"
  name "Gitify"
  desc "GitHub Notifications on your menu bar"
  homepage "https:github.comgitify-appgitify"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Gitify.app"

  preflight do
    retries ||= 3
    ohai "Attempting to close Gitify.app to avoid unwanted user intervention" if retries >= 3
    return unless system_command "usrbinpkill", args: ["-f", "ApplicationsGitify.app"]
  rescue RuntimeError
    sleep 1
    retry unless (retries -= 1).zero?
    opoo "Unable to forcibly close Gitify.app"
  end

  uninstall quit: [
    "com.electron.gitify",
    "com.electron.gitify.helper",
  ]

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.gitify.sfl*",
    "~LibraryApplication Supportgitify",
    "~LibraryCachescom.electron.gitify*",
    "~LibraryCachesgitify-updater",
    "~LibraryHTTPStoragescom.electron.gitify",
    "~LibraryPreferencescom.electron.gitify*.plist",
    "~LibrarySaved Application Statecom.electron.gitify.savedState",
  ]
end