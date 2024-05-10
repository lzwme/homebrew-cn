cask "synology-photo-station-uploader" do
  version "1.4.6,098"
  sha256 "6969aa9d75e8b8a57e64db6ff81e9fc8826c5a08432ccea7713b589cad9f7895"

  url "https://global.download.synology.com/download/Utility/PhotoStationUploader/#{version.csv.first}-#{version.csv.second}/Mac/SynologyPhotoStationUploader-#{version.csv.second}-Mac-Installer.dmg"
  name "Synology Photo Station Uploader"
  desc "Bulk upload photos and videos to Synology Photo Station"
  homepage "https://www.synology.com/"

  disable! date: "2024-05-09", because: :no_longer_available

  pkg "SynologyPhotoStationUploader-#{version.after_comma}-Mac-Installer.pkg"

  uninstall launchctl: [
              "com.synology.PhotoUploaderFinderSync",
              "com.synology.PhotoUploaderShellApp",
              "com.synology.PhotoUploaderUninstaller",
              "com.synology.SynoSIMBL_RefreshFinder",
            ],
            quit:      "com.synology.PhotoStationUploader",
            pkgutil:   [
              "com.synology.photostationuploader.installer",
              "inc.synology.photostationuploader",
            ]

  zap trash: [
        "~/Library/Application Scripts/com.synology.PhotoUploaderShellApp.PhotoUploaderFinderSync",
        "~/Library/Application Scripts/group.com.synology.PhotoUploader",
        "~/Library/Application Support/Synology/Photo Station Uploader",
        "~/Library/Containers/com.synology.PhotoUploaderShellApp.PhotoUploaderFinderSync",
        "~/Library/Group Containers/group.com.synology.PhotoUploader",
        "~/Library/Saved Application State/com.synology.PhotoStationUploader.savedState",
      ],
      rmdir: "~/Library/Application Support/Synology"
end