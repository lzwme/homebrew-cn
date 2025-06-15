cask "qview" do
  version "6.1"
  sha256 "e407b0f2fdd208ec72778feda0c34dcd12bc28420f9d5abd07e9287c1c91656a"

  url "https:github.comjurplelqViewreleasesdownload#{version}qView-#{version}.dmg"
  name "qView"
  desc "Image viewer"
  homepage "https:github.comjurplelqView"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "qView.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.interversehq.qview.sfl*",
    "~LibraryPreferencescom.interversehq.qView.plist",
    "~LibraryPreferencescom.qview.qView.plist",
    "~LibrarySaved Application Statecom.interversehq.qView.savedState",
  ]
end