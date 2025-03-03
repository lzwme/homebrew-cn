cask "gitify" do
  version "6.2.0"
  sha256 "aaa3b1f374465f3c4e2c24537b1477872aa39caefc933850fc0911d15e6d52dd"

  url "https:github.comgitify-appgitifyreleasesdownloadv#{version}Gitify-#{version}-universal-mac.zip"
  name "Gitify"
  desc "GitHub notifications on your menu bar"
  homepage "https:github.comgitify-appgitify"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

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