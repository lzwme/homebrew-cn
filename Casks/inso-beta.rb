cask "inso-beta" do
  version "9.0.0-beta.1"
  sha256 "bc5ebaa45307957c61715537830342b4069cf0648516052c5336c0b14a04f290"

  url "https:github.comKonginsomniareleasesdownloadlib%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  livecheck do
    url "https:github.comKonginsomniareleases?q=prerelease%3Atrue+Inso+CLI"
    regex(%r{href=["']?[^"' >]*?taglib%40([^"' >]+?)["' >]}i)
    strategy :page_match
  end

  conflicts_with cask: "inso"

  binary "inso"

  # No zap stanza required
end