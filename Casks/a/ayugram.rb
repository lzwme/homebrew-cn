cask "ayugram" do
  version "5.14.3"
  sha256 "983adee7f15829f986aeecbc2413616d77869f7278259c52361138055f319fbc"

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