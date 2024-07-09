cask "buzz" do
  version "1.0.0"
  sha256 "3b1ee2d7523faa3aaeacbf851cadc7dc57b26ca38871691a44d64f5d90940263"

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