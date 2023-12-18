cask "inso-beta" do
  version "8.4.0-beta.0"
  sha256 "8d675a813830776de03fbe8cae535197a258ebf0ef2b2901ff76e82d70c277fb"

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