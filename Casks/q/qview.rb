cask "qview" do
  version "7.0"
  sha256 "87a27f000dff7aed3e63a3da55a0a0f33637aec3b29556e5283de7a3e393a58b"

  url "https:github.comjurplelqViewreleasesdownload#{version}qView-#{version}.dmg"
  name "qView"
  desc "Image viewer"
  homepage "https:github.comjurplelqView"

  depends_on macos: ">= :monterey"

  app "qView.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.interversehq.qview.sfl*",
    "~LibraryPreferencescom.interversehq.qView.plist",
    "~LibraryPreferencescom.qview.qView.plist",
    "~LibrarySaved Application Statecom.interversehq.qView.savedState",
  ]
end