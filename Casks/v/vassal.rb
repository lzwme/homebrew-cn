cask "vassal" do
  version "3.7.16"
  sha256 "2d0319ba4b90f94cdae93de3971f06ef027ca84d9e2edb42b1f3bc7007dac8fd"

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