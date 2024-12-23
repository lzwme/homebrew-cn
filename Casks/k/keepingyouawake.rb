cask "keepingyouawake" do
  version "1.6.6"
  sha256 "e5feb78e52080ce46daccc80d5a65c7d7acd58b106b1212e23524c75f3d8943a"

  url "https:github.comnewmarcelKeepingYouAwakereleasesdownload#{version}KeepingYouAwake-#{version}.zip",
      verified: "github.comnewmarcelKeepingYouAwake"
  name "KeepingYouAwake"
  desc "Tool to prevent the system from going into sleep mode"
  homepage "https:keepingyouawake.app"

  livecheck do
    url "https:newmarcel.github.ioKeepingYouAwakeappcast.xml"
    strategy :sparkle, &:short_version
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