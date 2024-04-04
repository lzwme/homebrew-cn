cask "buzz" do
  version "0.8.4"
  sha256 "272c9010e23b7b1c47e6bf7db376238e7d2ab897efc1cb2ccfa4ea5ecd733feb"

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