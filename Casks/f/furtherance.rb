cask "furtherance" do
  version "24.10.3"
  sha256 "550bd27f3130acb40f6d6cf1748e4691f089ff2f77551b888db25daac4a8a992"

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