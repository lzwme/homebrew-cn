cask "ayugram" do
  version "5.8.3"
  sha256 "7769048139324700659f73f52b703a65abfb71e6768edc3d3298473565a31849"

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