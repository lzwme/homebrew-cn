cask "mailspring" do
  version "1.13.3"
  sha256 "99f7bb841b4b559b6a9ad28c044179907f8e1238797fa0c9979a410017605204"

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