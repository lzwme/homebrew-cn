cask "processing@3" do
  version "3.5.4,0270"
  sha256 "4d64fe42a6c5c0863cc82e93a036e73731999ee9448be45bc322f91b0010bb6b"

  url "https:github.comprocessingprocessingreleasesdownloadprocessing-#{version.csv.second}-#{version.csv.first}processing-#{version.csv.first}-macosx.zip",
      verified: "github.comprocessingprocessing"
  name "Processing"
  desc "Flexible software sketchbook and a language for learning how to code"
  homepage "https:processing.org"

  livecheck do
    url :url
    regex(^processing[._-](\d+(?:\.\d+)*)[@_-](3(?:\.\d+)+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  conflicts_with cask: [
    "processing",
    "processing2",
  ]

  app "Processing.app"

  uninstall quit: "org.processing.app"

  zap trash: [
    "~LibraryProcessing",
    "~Preferencesorg.processing.app.plist",
    "~Preferencesprocessing.app.tools.plist",
  ]
end