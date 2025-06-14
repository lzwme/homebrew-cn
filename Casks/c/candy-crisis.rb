cask "candy-crisis" do
  version "3.0.0"
  sha256 "4c3359332d950e2836f9279c8ed1cb32e3c271e5dccb182134364976b4ef2095"

  url "https:github.comjorioCandyCrisisreleasesdownloadv#{version}CandyCrisis-#{version}-mac.dmg",
      verified: "github.comjorioCandyCrisis"
  name "Candy Crisis"
  desc "Tile matching puzzleaction game"
  homepage "https:candycrisis.sourceforge.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Candy Crisis.app"

  zap trash: [
    "~LibraryApplication SupportCandyCrisis",
    "~LibraryContainerscom.cc.Candy-Crisis",
    "~LibrarySaved Application Stateio.jor.candycrisis.savedState",
  ]
end