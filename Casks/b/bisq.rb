cask "bisq" do
  version "1.9.14"
  sha256 "9289a41f653377d2a34cb0256f531b8ec57edc09311da85db8d084ee2e81d1f8"

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