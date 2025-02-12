cask "bisq" do
  version "1.9.19"
  sha256 "d28aa44da3a84093ae73cab73d911f074250015f25c891718871dddd69b8ccf8"

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