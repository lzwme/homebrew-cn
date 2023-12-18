cask "textmate" do
  version "2.0.23"
  sha256 "f8dba933209bd01070028892474bf0b72f36c673f7bcb8da5973f93ddc387420"

  url "https:github.comtextmatetextmatereleasesdownloadv#{version}TextMate_#{version}.tbz",
      verified: "github.comtextmatetextmate"
  name "TextMate"
  desc "General-purpose text editor"
  homepage "https:macromates.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "TextMate.app"
  binary "#{appdir}TextMate.appContentsMacOSmate"

  uninstall quit: "com.macromates.TextMate"

  zap trash: [
    "~LibraryApplication SupportTextMate",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.macromates.textmate.sfl2",
    "~LibraryCachescom.apple.helpdGeneratedTextMate #{version.major} Help*",
    "~LibraryCachescom.macromates.TextMate",
    "~LibraryPreferencescom.macromates.TextMate.plist",
    "~LibraryPreferencescom.macromates.TextMate.preview.plist",
    "~LibrarySaved Application Statecom.macromates.TextMate.savedState",
  ]
end