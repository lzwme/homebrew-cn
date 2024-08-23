cask "home-assistant" do
  version "2024.8,2024.783"
  sha256 "b47e62439047faa4efd99810bed2226a9dc46dbf786f2710eafbaf1e7a9df159"

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