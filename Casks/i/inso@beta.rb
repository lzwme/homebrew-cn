cask "inso@beta" do
  version "11.1.0-beta.2"
  sha256 "5ad0dc20a30d4a093cdc3c5656534b17cf39e112c1fffb00d50facdc9eb05d20"

  url "https:github.comKonginsomniareleasesdownloadcore%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  livecheck do
    url :url
    regex(^core@v?(\d+(?:\.\d+)+(?:[._-](?:beta|rc)[._-]?\d*)?)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "inso"

  binary "inso"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end