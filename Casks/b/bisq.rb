cask "bisq" do
  version "1.9.15"
  sha256 "8ad7e26024c002adb1e0a73bacca37ee81dd42ac5fdf7bb23980349870cc8a3c"

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