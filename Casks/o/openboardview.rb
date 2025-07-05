cask "openboardview" do
  version "9.95.1"
  sha256 "dcc5646053f2635ece1a88a8412c87aca738519d16becc38870520549b72db1a"

  url "https://ghfast.top/https://github.com/OpenBoardView/OpenBoardView/releases/download/#{version}/OpenBoardView-#{version}-Darwin.dmg",
      verified: "github.com/OpenBoardView/OpenBoardView/"
  name "OpenBoardView"
  desc "File viewer for .brd files"
  homepage "https://openboardview.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "openboardview.app"

  zap trash: "~/Library/Application Support/OpenBoardView"
end