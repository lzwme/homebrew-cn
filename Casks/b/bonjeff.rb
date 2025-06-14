cask "bonjeff" do
  version "2.0.1"
  sha256 "def276e47c60d8ffa7922356c6b6c7a90671590d283b48fb46d78a15dbd43772"

  url "https:github.comlapcatBonjeffreleasesdownloadv#{version}Bonjeff#{version}.zip"
  name "Bonjeff"
  desc "Shows a live display of the Bonjour services published on your network"
  homepage "https:github.comlapcatBonjeff"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Bonjeff.app"

  zap trash: [
    "~LibraryApplication Scriptscom.lapcatsoftware.bonjeff",
    "~LibraryContainerscom.lapcatsoftware.bonjeff",
  ]
end