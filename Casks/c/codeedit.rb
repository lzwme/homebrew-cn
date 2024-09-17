cask "codeedit" do
  version "0.3.2"
  sha256 "71119dfe8f81b863d82526963674597b5740fa794a2e27b9ca5b75798af65d31"

  url "https:github.comCodeEditAppCodeEditreleasesdownloadv#{version}CodeEdit.dmg",
      verified: "github.comCodeEditAppCodeEdit"
  name "CodeEdit"
  desc "Code editor"
  homepage "https:www.codeedit.app"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "CodeEdit.app"

  zap trash: [
    "~LibraryApplication Scripts*.CodeEdit.OpenWithCodeEdit",
    "~LibraryApplication SupportCodeEdit",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocuments*.codeedit.sfl*",
    "~LibraryCaches*.CodeEdit",
    "~LibraryContainers*.CodeEdit.OpenWithCodeEdit",
    "~LibraryHTTPStorages*.CodeEdit",
    "~LibraryPreferences*.CodeEdit.plist",
    "~LibrarySaved Application State*.CodeEdit.savedState",
  ]
end