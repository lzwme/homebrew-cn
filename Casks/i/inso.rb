cask "inso" do
  version "8.5.0"
  sha256 "44b8a1b5974c2a546cb803428450431b54c26424bb68de57337b5899da8a2ff8"

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