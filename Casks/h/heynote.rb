cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "c82de320188a5422c8fb0dff2bc11b69a114433b7a5b02bd99acb41152061500",
         intel: "656d44c6f6d8beadb34eee30181a3d9d677d8173846f692c622980f16bc12127"

  url "https:github.comheymanheynotereleasesdownloadv#{version}Heynote_#{version}_#{arch}.dmg",
      verified: "github.comheymanheynote"
  name "Heynote"
  desc "Dedicated scratchpad for developers"
  homepage "https:heynote.com"

  depends_on macos: ">= :catalina"

  app "Heynote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.heynote.app.sfl*",
    "~LibraryApplication SupportHeynote",
    "~LibraryLogsHeynote",
    "~LibraryPreferencescom.heynote.app.plist",
    "~LibrarySaved Application Statecom.heynote.app.savedState",
  ]
end