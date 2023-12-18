cask "bonjeff" do
  version "2.0.1"
  sha256 "def276e47c60d8ffa7922356c6b6c7a90671590d283b48fb46d78a15dbd43772"

  url "https:github.comlapcatBonjeffreleasesdownloadv#{version}Bonjeff#{version}.zip"
  name "Bonjeff"
  desc "Shows a live display of the Bonjour services published on your network"
  homepage "https:github.comlapcatBonjeff"

  depends_on macos: ">= :sierra"

  app "Bonjeff.app"

  zap trash: [
    "~LibraryApplication Scriptscom.lapcatsoftware.bonjeff",
    "~LibraryContainerscom.lapcatsoftware.bonjeff",
  ]
end