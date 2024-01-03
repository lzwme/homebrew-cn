cask "mailspring" do
  version "1.13.2"
  sha256 "fd34276541ed1661464698415f550be529fa19c40d39c953a278bb228131ab7b"

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