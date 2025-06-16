cask "moves" do
  version "1.8.0"
  sha256 "c1476ffc9835468ed7b4a214521fa046a1be3b7724eaab6085c49f7d6589d376"

  url "https:github.commikkerMoves.appreleasesdownloadv#{version}Moves.app.zip",
      verified: "github.commikkerMoves.app"
  name "Moves"
  desc "Window manager"
  homepage "https:mikkelmalmberg.commoves"

  livecheck do
    url "https:mikker.github.ioMoves.appappcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Moves.app"

  zap trash: "~LibraryApplication SupportMoves"
end