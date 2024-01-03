cask "pile" do
  arch arm: "-arm64", intel: ""

  version "0.9.2"
  sha256 arm:   "9e73f64231e988be8b60050e8f8cfed8dab06982e6b2f0683da6ba2343380774",
         intel: "54e482eb0ba672299e72f2ba775d8883be5690723dad7687796148514dc1ab7c"

  url "https:github.comUdaraJayPilereleasesdownloadv#{version}Pile-#{version}#{arch}.dmg",
      verified: "github.comUdaraJayPile"
  name "Pile"
  desc "Digital journaling app"
  homepage "https:udara.iopile"

  # auto-updates are coming with 1.0.0
  # https:github.comUdaraJayPileissues40#issuecomment-1873501788
  # auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Pile.app"

  zap trash: "~LibraryPreferencespile.un.ms.plist"
end