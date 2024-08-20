cask "gitify" do
  version "5.13.0"
  sha256 "570d50d4ab19485b0daf739d24ca8f45bcf89bb57ebd1c60ad2f7fbd93c8ea60"

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