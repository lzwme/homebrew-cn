cask "furtherance" do
  version "24.10.5"
  sha256 "01d772fd27c5269cc0d7a2b2609b196fdf7a41e9089083ef1ec9079625e3e769"

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