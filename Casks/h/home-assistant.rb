cask "home-assistant" do
  version "2023.12,2023.499"
  sha256 "364d9a491bc5e7c75ec4117ca3e3e5d0fcbb62675de7f8a6cb1306236a7d8089"

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