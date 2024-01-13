cask "vassal" do
  version "3.7.7"
  sha256 "68c9ef2af8f94dc4302caab72da1a9bb25262299a5af0e9ad5d2c0622988d126"

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