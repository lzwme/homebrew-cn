cask "qfinder-pro" do
  version "7.11.3,1126"
  sha256 "539d51b0ae240b7ce24906e802c3ac1c09ea33e9475815fcd0c703c29eed7068"

  url "https://download.qnap.com/Storage/Utility/QNAPQfinderProMac-#{version.csv.first}.#{version.csv.second}.dmg"
  name "Qnap Qfinder Pro"
  desc "NAS management application"
  homepage "https://www.qnap.com/en/utilities#utliity_5"

  livecheck do
    url "https://update.qnap.com/SoftwareRelease.xml"
    strategy :xml do |xml|
      item = xml.elements[
        "//application[productName[text()='Qfinder']]" \
        "/platform[platformName[text()='Mac_for_QT']]/software"
      ]
      next if item.blank?

      version = item.elements["version"]&.text&.strip
      build = item.elements["buildNumber"]&.text&.strip
      next if version.blank? || build.blank?

      "#{version},#{build}"
    end
  end

  pkg "Qfinder Pro.pkg"

  uninstall launchctl: "com.qnap.qsoftwareupdater",
            pkgutil:   "qnap.com.Qfinder"

  zap trash: [
        "~/Library/Application Support/QNAP/QfinderPro",
        "~/Library/Preferences/QNAP/Qfinder.plist",
        "~/Library/Saved Application State/qnap.com.qfinder.savedState",
      ],
      rmdir: [
        "~/Library/Application Support/QNAP",
        "~/Library/Preferences/QNAP",
      ]
end