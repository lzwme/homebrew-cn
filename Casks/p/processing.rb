cask "processing" do
  arch arm: "aarch64", intel: "x64"

  version "4.4.4,1304"
  sha256 arm:   "cafda7bc5e063644e5f2c93b00e4613d9eeced4f29600203b3bff2d23242ad62",
         intel: "8b9c9c0a2f27d96a9703a3dbe7c8f6d0f0d9c583ccc0d321fae5364d509edd82"

  url "https:github.comprocessingprocessing4releasesdownloadprocessing-#{version.csv.second}-#{version.csv.first}processing-#{version.csv.first}-macos-#{arch}.dmg",
      verified: "github.comprocessingprocessing4"
  name "Processing"
  desc "Flexible software sketchbook and a language for learning how to code"
  homepage "https:processing.org"

  # GitHub releases may not always provide macOS files at the time the release
  # is created. The first-party download page links to GitHub release assets,
  # so we can use that to identify the latest stable release with a macOS file.
  livecheck do
    url "https:processing.orgpage-datadownloadpage-data.json"
    regex(^processing[._-](\d+(?:\.\d+)*)[@_-](\d+(?:\.\d+)+)$i)
    strategy :json do |json, regex|
      json.dig("result", "data", "releases", "nodes")&.filter_map do |node|
        match = node.dig("childJson", "tagName")&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  conflicts_with cask: "processing@3"
  depends_on macos: ">= :mojave"

  app "Processing.app"

  uninstall quit: "org.processing.app"

  zap trash: [
    "~LibraryPreferencesorg.processing.app.plist",
    "~LibraryPreferencesorg.processing.four.plist",
    "~LibraryPreferencesprocessing.app.tools.plist",
    "~LibraryProcessing",
  ]
end