cask "bisq" do
  version "1.9.17"
  sha256 "4ae9f1d1e8655616e4115a4038230248db4d2d238af19780d2f25fff576b0888"

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

  caveats do
    requires_rosetta
  end
end