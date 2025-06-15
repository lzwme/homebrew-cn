cask "qsync-client" do
  version "5.1.4,1504"
  sha256 "35ebba1b46101ee27f288c860ef521d7565f96d7b225bd6a4c85b7031b624f5c"

  url "https://download.qnap.com/Storage/Utility/QNAPQsyncClientMac-#{version.csv.first}.#{version.csv.second}.dmg"
  name "Qnap Qsync"
  desc "Automatic file synchronisation"
  homepage "https://www.qnap.com/en/utilities/essentials#utliity_3"

  livecheck do
    url "https://update.qnap.com/SoftwareRelease.xml"
    strategy :xml do |xml|
      item = xml.elements["//application[productName[text()='Qsync']]/platform[platformName[text()='Mac']]/software"]
      next if item.blank?

      version = item.elements["version"]&.text&.strip
      build = item.elements["buildNumber"]&.text&.strip
      next if version.blank? || build.blank?

      "#{version},#{build}"
    end
  end

  no_autobump! because: :requires_manual_review

  installer manual: "Qsync Client.pkg"

  uninstall quit:    [
              "com.qnap.qsync",
              "com.qnap.qsync.findersync",
            ],
            pkgutil: "com.qnap.qsync"

  zap trash: [
    "~/Library/Application Scripts/com.qnap.qsync",
    "~/Library/Application Scripts/com.qnap.qsync.findersync",
    "~/Library/Containers/com.qnap.qsync",
    "~/Library/Containers/com.qnap.qsync.findersync",
    "~/Library/Group Containers/group.com.qnap.qsync",
  ]
end