cask "processing" do
  arch arm: "aarch64", intel: "x64"

  version "4.3.2,1295"
  sha256 arm:   "13054fe60d8a07c36d98146c51c4d016804ea463c392cb9d14a3125c2d3cf023",
         intel: "3da6dbe0166858d387337f951fb50ec74822a4378e0806d1dbcc5349b784e267"

  url "https:github.comprocessingprocessing4releasesdownloadprocessing-#{version.csv.second}-#{version.csv.first}processing-#{version.csv.first}-macos-#{arch}.zip",
      verified: "github.comprocessingprocessing4"
  name "Processing"
  desc "Flexible software sketchbook and a language for learning how to code"
  homepage "https:processing.org"

  livecheck do
    url :url
    regex(^processing[._-](\d+(?:\.\d+)*)[@_-](\d+(?:\.\d+)+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[1]},#{match[0]}" }
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