cask "keepingyouawake" do
  version "1.6.5"
  sha256 "4e9d879c95cbf8e25370974c2b8875f17b2aa3b9c295bb76d0da74cd833afe04"

  url "https:github.comnewmarcelKeepingYouAwakereleasesdownload#{version}KeepingYouAwake-#{version}.zip",
      verified: "github.comnewmarcelKeepingYouAwake"
  name "KeepingYouAwake"
  desc "Tool to prevent the system from going into sleep mode"
  homepage "https:keepingyouawake.app"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "KeepingYouAwake.app"

  uninstall quit: "info.marcel-dierkes.KeepingYouAwake"

  zap trash: [
    "~LibraryApplication Scriptsinfo.marcel-dierkes.KeepingYouAwake",
    "~LibraryApplication Scriptsinfo.marcel-dierkes.KeepingYouAwake.Launcher",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsinfo.marcel-dierkes.keepingyouawake.sfl*",
    "~LibraryApplication Supportinfo.marcel-dierkes.KeepingYouAwake",
    "~LibraryCachesinfo.marcel-dierkes.KeepingYouAwake",
    "~LibraryContainersinfo.marcel-dierkes.KeepingYouAwake",
    "~LibraryContainersinfo.marcel-dierkes.KeepingYouAwake.Launcher",
    "~LibraryCookiesinfo.marcel-dierkes.KeepingYouAwake.binarycookies",
    "~LibraryPreferencesinfo.marcel-dierkes.KeepingYouAwake.plist",
    "~LibrarySaved Application Stateinfo.marcel-dierkes.KeepingYouAwake.savedState",
  ]
end