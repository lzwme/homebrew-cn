cask "codeedit" do
  version "0.1.0"
  sha256 "0602900471039be43783d0192579349b19ebe936cd61ec382b5b63d4e0001962"

  url "https:github.comCodeEditAppCodeEditreleasesdownloadv#{version}CodeEdit.dmg",
      verified: "github.comCodeEditAppCodeEdit"
  name "CodeEdit"
  desc "Code editor"
  homepage "https:www.codeedit.app"

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