cask "inso@beta" do
  version "11.0.0-beta.7"
  sha256 "ae1811ae2685b8d46c2d7798bea7de143334de16c5aae7cb80c1f4cf35b1c4c7"

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