cask "pile" do
  arch arm: "-arm64"

  version "0.9.4"
  sha256 arm:   "2d833b226b92664c9a2b6a3fccb5fa0b70eb75233d78c67fab66cd7381afacc1",
         intel: "dadfc78b98bac2bff83d567384d5b0d19518bc7e6c8457a406bc700c164fd34c"

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