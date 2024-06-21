cask "bisq" do
  version "1.9.16"
  sha256 "d4997837d7ca26be1f6407c0ff367919be91c988e5e305aab7c7e4e8459a8115"

  url "https:github.combisq-networkbisqreleasesdownloadv#{version}Bisq-#{version}.dmg",
      verified: "github.combisq-networkbisq"
  name "Bisq"
  desc "Decentralised bitcoin exchange network"
  homepage "https:bisq.network"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Bisq.app"

  zap trash: [
    "~LibraryApplication SupportBisq",
    "~LibrarySaved Application Stateio.bisq.CAT.savedState",
  ]
end