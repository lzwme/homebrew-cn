cask "inso@beta" do
  version "10.1.0-beta.3"
  sha256 "5de438d6182f603285eaab194ad062d03700ce79536a189db09aa68ff5f22871"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  livecheck do
    url "https:github.comKonginsomniareleases?q=prerelease%3Atrue+Inso+CLI"
    regex(%r{href=["']?[^"' >]*?tagcore%40([^"' >]+?)["' >]}i)
    strategy :page_match
  end

  conflicts_with cask: "inso"

  binary "inso"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end