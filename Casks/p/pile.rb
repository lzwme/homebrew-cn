cask "pile" do
  arch arm: "-arm64"

  version "0.9.6"
  sha256 arm:   "d3c0b8ced13d9103f2ae6afda21359d64c211528a2f15ac9ce652b5249baf4ba",
         intel: "787221c7a5a13249c9dde9aad0db145d80dae10cf75ec9060d4ae151089f197f"

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