cask "drawbot" do
  version "3.131"
  sha256 "da03cd73d2c7ea221977fddd0b77856d0076f4d3833fdd0580823cc76dcaa0dc"

  url "https:github.comtypemytypedrawbotreleasesdownload#{version}DrawBot.dmg",
      verified: "github.comtypemytypedrawbot"
  name "DrawBot"
  desc "Write Python scripts to generate two-dimensional graphics"
  homepage "https:www.drawbot.com"

  app "DrawBot.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.drawbot.sfl*",
    "~LibraryPreferencescom.drawbot.plist",
    "~LibrarySaved Application Statecom.drawbot.savedState",
  ]
end