cask "furtherance" do
  version "25.1.2"
  sha256 "37e47729facd31624cb84f91df1e34673f1597936a4f6c75a4472ff3acd6a372"

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