cask "gephi" do
  arch arm: "aarch64", intel: "x64"

  version "0.10.1"
  sha256 arm:   "cbb852d2f33cddf793290a64aee564cd46ad80ef6c51766ad05dfeb801ac7227",
         intel: "abc7ca1ba7f2a91e51af716ad0a1a785a798f7bb7100841dfdb775895919f508"

  url "https:github.comgephigephireleasesdownloadv#{version}gephi-#{version}-macos-#{arch}.dmg",
      verified: "github.comgephigephi"
  name "Gephi"
  desc "Open-source platform for visualizing and manipulating large graphs"
  homepage "https:gephi.org"

  no_autobump! because: :requires_manual_review

  app "Gephi.app"

  zap trash: [
    "~LibraryApplication Supportgephi",
    "~LibraryCachesgephi",
  ]
end