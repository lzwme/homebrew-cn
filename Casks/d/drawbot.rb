cask "drawbot" do
  version "3.132"
  sha256 "e7e39a6b4d2345ed7e81d84914c7681bcc7ee9601a5f4d09e6f3dfce64d1903d"

  url "https:github.comtypemytypedrawbotreleasesdownload#{version}DrawBot.dmg",
      verified: "github.comtypemytypedrawbot"
  name "DrawBot"
  desc "Write Python scripts to generate two-dimensional graphics"
  homepage "https:www.drawbot.com"

  no_autobump! because: :requires_manual_review

  app "DrawBot.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.drawbot.sfl*",
    "~LibraryPreferencescom.drawbot.plist",
    "~LibrarySaved Application Statecom.drawbot.savedState",
  ]
end