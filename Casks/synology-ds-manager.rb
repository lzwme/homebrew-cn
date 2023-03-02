cask "synology-ds-manager" do
  version "1.4.2,12"
  sha256 "70202cdd2410ce04f94b830b3a8ff1b89104e37a1ea4e071b9595bcc84b13019"

  url "https://swiftapps.skavans.ru/synology-ds-manager-mac/versions/SynologyDSManager-#{version.csv.first}.zip"
  name "Synology DS Manager"
  desc "Synology Download Station application and Safari Extension"
  homepage "https://swiftapps.skavans.ru/synology-ds-manager-mac/"

  livecheck do
    url "https://swiftapps.skavans.ru/synology-ds-manager-mac/versions/appcast.xml"
    regex(/sparkle:version="([^"]*)" sparkle:shortVersionString="([^"]*)"/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[1] + "," + match[0] }
    end
  end

  app "SynologyDSManager.app"

  zap trash: [
    "~/Library/Application Scripts/com.skavans.synologyDSManager",
    "~/Library/Application Scripts/com.skavans.synologyDSManager.extension",
    "~/Library/Containers/com.skavans.synologyDSManager",
    "~/Library/Containers/com.skavans.synologyDSManager.extension",
  ]
end