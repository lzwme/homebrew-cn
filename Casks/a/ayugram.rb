cask "ayugram" do
  version "5.12.3"
  sha256 "8461dd116e13aece1c6ac28b19f71795848d10b74f4d04ce547d96f4fbc0ef95"

  url "https:github.comAyuGramAyuGramDesktopreleasesdownloadv#{version}AyuGram.dmg"
  name "AyuGram"
  desc "Telegram client with ghost mode and message history"
  homepage "https:github.comAyuGramAyuGramDesktop"

  depends_on macos: ">= :high_sierra"

  app "AyuGram.app"

  zap trash: [
    "~LibraryApplication SupportAyuGram Desktop",
    "~LibrarySaved Application Stateone.ayugram.AyuGramDesktop.savedState",
  ]
end