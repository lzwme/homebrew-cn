cask "cantata" do
  version "2.3.2"
  sha256 "c9eb8a1102d0a68cafc93f22df73445b8f69706f3322285f9a2f623a28df0176"

  url "https:github.comCDrummondcantatareleasesdownloadv#{version}Cantata-#{version}.dmg"
  name "Cantata"
  desc "Qt5 Graphical MPD Client"
  homepage "https:github.comcdrummondcantata"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"

  app "Cantata.app"
end