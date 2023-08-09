cask "inso-beta" do
  version "3.19.0-beta.9"
  sha256 "c3a945d469b6c91c22d7d956b8aeace1c1da6ec1f7a68ea465a3ce3a58e68344"

  url "https://ghproxy.com/https://github.com/Kong/insomnia/releases/download/lib%40#{version}/inso-macos-#{version}.zip",
      verified: "github.com/Kong/insomnia/"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https://insomnia.rest/products/inso"

  livecheck do
    url "https://github.com/Kong/insomnia/releases?q=prerelease%3Atrue+Inso+CLI"
    regex(%r{href=["']?[^"' >]*?/tag/lib%40([^"' >]+?)["' >]}i)
    strategy :page_match
  end

  conflicts_with cask: "inso"

  binary "inso"

  # No zap stanza required
end