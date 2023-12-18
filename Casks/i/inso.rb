cask "inso" do
  version "8.4.5"
  sha256 "f661639a048a6e5a2519002cc2c2f1671b51dcbcffb5b1805991d6786ba31527"

  url "https:github.comKonginsomniareleasesdownloadlib%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  # Upstream previously used a date-based version scheme (e.g., `2023.5.8`)
  # before switching to a typical `8.1.0` format. The date-based versions are
  # numerically higher, so we have to avoid matching them.
  livecheck do
    url :url
    regex(^lib@v?(\d{1,3}(?:\.\d+)+)$i)
  end

  conflicts_with cask: "homebrewcask-versionsinso-beta"

  binary "inso"

  # No zap stanza required
end