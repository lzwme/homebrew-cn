cask "mailspring" do
  arch arm: "-AppleSilicon"

  version "1.15.0"
  sha256 arm:   "705ceaa81036e529a3f65fa7bda6621cf02718a0044346fbe64b34b9674a089d",
         intel: "ec9a1e11436c93281da03ccc6f7877ac364a269b45d6e0c2dc7a3a55b42318e7"

  url "https:github.comFoundry376Mailspringreleasesdownload#{version}Mailspring#{arch}.zip",
      verified: "github.comFoundry376Mailspring"
  name "Mailspring"
  desc "Fork of Nylas Mail"
  homepage "https:getmailspring.com"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Mailspring.app"

  zap trash: [
    "~LibraryApplication SupportMailspring",
    "~LibraryCachescom.mailspring.*",
    "~LibraryLogsMailspring",
    "~LibraryPreferencescom.mailspring.*",
    "~LibrarySaved Application Statecom.mailspring.*",
  ]
end