cask "juice" do
  version "2017.06.08170217"
  sha256 "ee308adbd3ee827c2735931844a10f0f779f8953204aeaacb0eb64705244b310"

  url "https:github.combrianmichelJuicereleasesdownloadbuilds%2Fbeta%2F#{version}Juice-Beta-#{version}.dmg"
  name "Juice"
  desc "Make your battery information a bit more interesting"
  homepage "https:github.combrianmichelJuice"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Juice.app"

  zap trash: [
    "~LibraryContainerscom.bsm.macos.Juice",
    "~LibraryContainerscom.bsm.macos.JuiceHelper",
  ]
end