cask "pile" do
  arch arm: "-arm64"

  version "0.9.9"
  sha256 arm:   "2de912e6c8fb688c00ed4539a20bdf6f3f227a754487c6234fe5ec3b5822efcf",
         intel: "44e4415c80278a9a26b8ab38541d34147419d53808f37d32827f1e0a821ed320"

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