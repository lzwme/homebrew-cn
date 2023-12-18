cask "processing" do
  arch arm: "aarch64", intel: "x64"

  version "4.3,1293"
  sha256 arm:   "bccec62845344357533f83c6777cda8ea127308219f23d1d94416b8cc0c0612a",
         intel: "6e5593c107439b199e14c4b0fd2bef88cf09e7cba7550c5ca6f2f912ce999b82"

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

  conflicts_with cask: [
    "homebrewcask-versionsprocessing2",
    "homebrewcask-versionsprocessing3",
  ]
  depends_on macos: ">= :catalina"

  app "Processing.app"

  uninstall quit: "org.processing.app"

  zap trash: [
    "~LibraryProcessing",
    "~Preferencesorg.processing.app.plist",
    "~Preferencesorg.processing.four.plist",
    "~Preferencesprocessing.app.tools.plist",
  ]
end