cask "notion-enhanced" do
  version "2.0.18-1"
  sha256 "e54a37053ed52a42ecbb4ed22a0ce50498ecc1efb3bff5b134099a56a8569309"

  url "https:github.comnotion-enhancernotion-repackagedreleasesdownloadv#{version}Notion-Enhanced-#{version}.dmg",
      verified: "github.comnotion-enhancer"
  name "Notion Enhanced"
  desc "Enhancercustomiser for the all-in-one productivity workspace notion.so"
  homepage "https:notion-enhancer.github.io"

  no_autobump! because: :requires_manual_review

  app "Notion Enhanced.app"

  zap trash: [
    "~LibraryLogsNotion Enhanced",
    "~LibraryPreferencescom.github.notion-repackaged.plist",
    "~LibrarySaved Application Statecom.github.notion-repackaged.savedState",
  ]
end