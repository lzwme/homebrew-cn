cask "inso@beta" do
  version "10.1.0-beta.1"
  sha256 "a52580688020397be4fcf9bb935f50de116a02ff2aa8028f5d953597afda22ed"

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