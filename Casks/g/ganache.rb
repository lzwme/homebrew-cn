cask "ganache" do
  version "2.7.1"
  sha256 "e2e0fd17d4e2e3e42b007bf2e6f88a99da49d9d20cc8443b857f8183d64e76fe"

  url "https:github.comtrufflesuiteganache-uireleasesdownloadv#{version}Ganache-#{version}-mac.dmg",
      verified: "github.comtrufflesuiteganache-ui"
  name "Ganache"
  desc "Personal blockchain for Ethereum development"
  homepage "https:trufflesuite.comganache"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Ganache.app"

  zap trash: [
    "~LibraryApplication SupportGanache",
    "~LibraryLogsGanache",
    "~LibraryPreferencesorg.trufflesuite.ganache.plist",
    "~LibrarySaved Application Stateorg.trufflesuite.ganache.savedState",
  ]

  caveats do
    <<~EOS
      See https:consensys.ioblogconsensys-announces-the-sunset-of-truffle-and-ganache-and-new-hardhat for information
    EOS
  end
end