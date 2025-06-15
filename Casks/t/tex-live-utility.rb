cask "tex-live-utility" do
  version "1.54"
  sha256 "983178326b457b77324151c304269ecaf7ae93aec62e8509c0badf52c718995e"

  url "https:github.comamaxwelltlutilityreleasesdownload#{version}TeX.Live.Utility.app-#{version}.zip"
  name "TeX Live Utility"
  desc "Graphical user interface for TeX Live Manager"
  homepage "https:github.comamaxwelltlutility"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "TeX Live Utility.app"

  zap trash: [
    "~LibraryApplication SupportTeX Live Utility",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileTeX Live Utility Help*",
    "~LibraryCachescom.googlecode.mactlmgr.tlu",
    "~LibraryHTTPStoragescom.googlecode.mactlmgr.tlu",
    "~LibraryHTTPStoragescom.googlecode.mactlmgr.tlu.binarycookies",
    "~LibraryPreferencescom.googlecode.mactlmgr.tlu.plist",
    "~LibrarySaved Application Statecom.googlecode.mactlmgr.tlu.savedState",
  ]
end