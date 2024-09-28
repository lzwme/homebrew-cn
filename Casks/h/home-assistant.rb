cask "home-assistant" do
  version "2024.9.2,2024.881"
  sha256 "9a86eece681fe3fcccf43ea4314bef02bbadbb68baa3fe1998c7c17999b20962"

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