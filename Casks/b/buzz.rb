cask "buzz" do
  version "1.0.1"
  sha256 "86e3b580ee99e3dd78b92eaad620d2a823a26788a371a29cc65db1b8e3ec4222"

  url "https:github.comchidiwilliamsbuzzreleasesdownloadv#{version}Buzz-#{version}-mac.dmg"
  name "Buzz"
  desc "Transcribes and translates audio"
  homepage "https:github.comchidiwilliamsbuzz"

  deprecate! date: "2024-04-03", because: :moved_to_mas

  app "Buzz.app"

  zap trash: [
    "~LibraryCachesBuzz",
    "~LibraryLogsBuzz",
    "~LibraryPreferencescom.chidiwilliams.buzz.plist",
    "~LibrarySaved Application Statecom.chidiwilliams.buzz.savedState",
  ]
end