cask "processing" do
  arch arm: "aarch64", intel: "x64"

  version "4.3.1,1294"
  sha256 arm:   "5f1e1e91001dfca14e9ae8d6cc10f95f0b65f91a13e87ff16e3ebd4a7138ca52",
         intel: "6299de8093f79b267876f256ef139bdfdcf7dd265e61111e9fda75189adcdee0"

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