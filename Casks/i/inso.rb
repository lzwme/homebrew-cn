cask "inso" do
  version "11.0.0"
  sha256 "ef79b37e04dfc5892d733bfe42f8d29da041695d3a068b50ceede365d1c33a3a"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  livecheck do
    url :url
    regex(^core@v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  conflicts_with cask: "inso@beta"

  binary "inso"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end