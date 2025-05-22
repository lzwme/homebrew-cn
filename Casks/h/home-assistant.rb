cask "home-assistant" do
  version "2025.5,2025.1264"
  sha256 "9c137cb7e893c58e9f5bc803a11695a015c5b084fe2f4941ca9e84fef2d315cb"

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

  depends_on macos: ">= :monterey"

  app "Home Assistant.app"

  zap trash: [
    "~LibraryApplication Scriptsio.robbie.HomeAssistant",
    "~LibraryContainersio.robbie.HomeAssistant",
    "~LibraryGroup Containersgroup.io.robbie.homeassistant",
  ]
end