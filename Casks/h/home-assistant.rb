cask "home-assistant" do
  version "2024.6,2024.696"
  sha256 "d00a1b021bd981c90dbf98b2f61b13972a5f204e9f1e05a1d5bd2bb60052ec24"

  url "https:github.comhome-assistantiOSreleasesdownloadrelease%2F#{version.csv.first}%2F#{version.csv.second}home-assistant-mac.zip",
      verified: "github.comhome-assistantiOS"
  name "Home Assistant"
  desc "Companion app for Home Assistant home automation software"
  homepage "https:companion.home-assistant.io"

  livecheck do
    url :url
    regex(%r{^(?:mac|release)(\d+(?:\.\d+)+)(\d+(?:\.\d+)*)}i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  depends_on macos: ">= :catalina"

  app "Home Assistant.app"

  zap trash: [
    "~LibraryApplication Scriptsio.robbie.HomeAssistant",
    "~LibraryContainersio.robbie.HomeAssistant",
    "~LibraryGroup Containersgroup.io.robbie.homeassistant",
  ]
end