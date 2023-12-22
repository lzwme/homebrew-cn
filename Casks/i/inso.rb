cask "inso" do
  version "8.5.1"
  sha256 "ea5708f44530a8f7dd7aa9ca651461cba4d6bdf7e079e2613b5dc2a374c2d8e8"

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