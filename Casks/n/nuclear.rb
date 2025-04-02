cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.45"
  sha256 arm:   "9f7811def8e9e3ad82a98c0844981f6268e7165248a382a2a787ffe06a663308",
         intel: "51a3f5eb36437acb3cc13812b8318606a78b808d092ef32fbe8f99315b465d2c"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]
end