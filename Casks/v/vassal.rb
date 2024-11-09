cask "vassal" do
  version "3.7.15"
  sha256 "a8da627afd7fcd0f05e809a14bb52103ca98fb9e1ff62bd5b962871e38db4639"

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