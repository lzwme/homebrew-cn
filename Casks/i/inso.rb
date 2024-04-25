cask "inso" do
  version "9.0.0"
  sha256 "d3a82af18d33b09570fcb40a34415fd8af151d8d123c622a7b5057b9fa27abc0"

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