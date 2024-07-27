cask "vassal" do
  version "3.7.13"
  sha256 "8f0135fb440e7021d3503fa1e8c6fc9709cf5736af076e96fefbe97cdf5f70fd"

  url "https:github.comvassalenginevassalreleasesdownload#{version}VASSAL-#{version}-macos-universal.dmg",
      verified: "github.comvassalenginevassal"
  name "VASSAL"
  desc "Board game engine"
  homepage "https:www.vassalengine.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "VASSAL.app"

  zap trash: "~LibraryApplication SupportVASSAL"
end