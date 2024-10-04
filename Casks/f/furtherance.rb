cask "furtherance" do
  version "24.10.0"
  sha256 "96c093b5a5ecd4c055ead308e21daf02e1096053ee8cceed86e332303a931205"

  url "https:github.comunobserved-ioFurtherancereleasesdownload#{version}furtherance-#{version}.dmg",
      verified: "github.comunobserved-ioFurtherance"
  name "Furtherance"
  desc "Time tracker"
  homepage "https:furtherance.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "Furtherance.app"

  zap trash: "~LibraryApplication Supportio.unobserved.furtherance"
end