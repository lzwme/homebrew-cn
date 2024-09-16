cask "mailspring" do
  version "1.14.0"
  sha256 "1e7ffda30359062d0edf89cec8ac2e0fbf04727873715c2e6b7944d3f4dc5df9"

  url "https:github.comFoundry376Mailspringreleasesdownload#{version}Mailspring.zip",
      verified: "github.comFoundry376Mailspring"
  name "Mailspring"
  desc "Fork of Nylas Mail"
  homepage "https:getmailspring.com"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Mailspring.app"

  zap trash: [
    "~LibraryApplication SupportMailspring",
    "~LibraryCachescom.mailspring.*",
    "~LibraryLogsMailspring",
    "~LibraryPreferencescom.mailspring.*",
    "~LibrarySaved Application Statecom.mailspring.*",
  ]
end