cask "mailspring" do
  arch arm: "-AppleSilicon"

  version "1.15.1"
  sha256 arm:   "30c276ea9dcaa7fac132dcae3850f2be6033e49d05730e6d8859cc88f677e2f0",
         intel: "a9cf0158ef2e35070b5f94fc8b6ac2ddf36cbae68465cf638cf56d9fd54658f6"

  url "https:github.comFoundry376Mailspringreleasesdownload#{version}Mailspring#{arch}.zip",
      verified: "github.comFoundry376Mailspring"
  name "Mailspring"
  desc "Fork of Nylas Mail"
  homepage "https:getmailspring.com"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Mailspring.app"

  zap trash: [
    "~LibraryApplication SupportMailspring",
    "~LibraryCachescom.mailspring.*",
    "~LibraryLogsMailspring",
    "~LibraryPreferencescom.mailspring.*",
    "~LibrarySaved Application Statecom.mailspring.*",
  ]
end