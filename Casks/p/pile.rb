cask "pile" do
  arch arm: "-arm64"

  version "0.9.7"
  sha256 arm:   "acff68e8aa891895de6cfedfa477163c7045720a2ef8509154044fedb876b98f",
         intel: "ad6bfd5f5076b9c226a37f55032f20e1ebd1b6b73add54db3e1b57200067dbcc"

  url "https:github.comUdaraJayPilereleasesdownloadv#{version}Pile-#{version}#{arch}.dmg",
      verified: "github.comUdaraJayPile"
  name "Pile"
  desc "Digital journaling app"
  homepage "https:udara.iopile"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Pile.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentspile.un.ms.sfl*",
    "~LibraryApplication Supportpile",
    "~LibraryPreferencespile.un.ms.plist",
    "~LibrarySaved Application Statepile.un.ms.savedState",
    "~Piles",
  ]
end