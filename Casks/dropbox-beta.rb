cask "dropbox-beta" do
  arch arm: "&arch=arm64"

  version "170.3.5866"
  sha256 arm:   "69901f6df3b240704c0de4e607f8e7f548a6d001690d59afa913a1e1aeb31367",
         intel: "cfe21eaf264674847ed8513aa8c49b4cca19969ce56ba12ec3878433c6dc498d"

  url "https://www.dropbox.com/download?build=#{version}&plat=mac&type=full#{arch}",
      verified: "dropbox.com/"
  name "Dropbox"
  desc "Client for the Dropbox cloud storage service"
  homepage "https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016"

  livecheck do
    url :homepage
    regex(/Beta\sBuild\s(\d+(?:\.\d+)+)/i)
  end

  auto_updates true
  conflicts_with cask: "dropbox"

  app "Dropbox.app"

  uninstall launchctl: "com.dropbox.DropboxMacUpdate.agent",
            kext:      "com.getdropbox.dropbox.kext",
            delete:    [
              "/Library/DropboxHelperTools",
              "/Library/Preferences/com.getdropbox.dropbox.dbkextd.plist",
            ]

  zap trash: [
    "~/.dropbox",
    "~/Library/Application Scripts/*.com.getdropbox.dropbox.sync",
    "~/Library/Application Scripts/com.dropbox.alternatenotificationservice",
    "~/Library/Application Scripts/com.dropbox.client.crashpad",
    "~/Library/Application Scripts/com.dropbox.foldertagger",
    "~/Library/Application Scripts/com.getdropbox.dropbox.fileprovider",
    "~/Library/Application Scripts/com.getdropbox.dropbox.garcon",
    "~/Library/Application Scripts/com.getdropbox.dropbox.TransferExtension",
    "~/Library/Application Support/Dropbox",
    "~/Library/Application Support/DropboxElectron",
    "~/Library/Application Support/FileProvider/com.getdropbox.dropbox.fileprovider",
    "~/Library/Caches/CloudKit/com.apple.bird/iCloud.com.getdropbox.Dropbox",
    "~/Library/Caches/com.dropbox.DropboxMacUpdate",
    "~/Library/Caches/com.getdropbox.dropbox",
    "~/Library/Caches/com.getdropbox.DropboxMetaInstaller",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.dropbox.DropboxMacUpdate",
    "~/Library/CloudStorage/Dropbox",
    "~/Library/Containers/com.dropbox.activityprovider",
    "~/Library/Containers/com.dropbox.alternatenotificationservice",
    "~/Library/Containers/com.dropbox.foldertagger",
    "~/Library/Containers/com.getdropbox.dropbox.fileprovider",
    "~/Library/Containers/com.getdropbox.dropbox.garcon",
    "~/Library/Containers/com.getdropbox.dropbox.TransferExtension",
    "~/Library/Dropbox",
    "~/Library/Dropbox/DropboxMacUpdate.app/Contents/MacOS/DropboxMacUpdate",
    "~/Library/Group Containers/*.com.getdropbox.dropbox.sync",
    "~/Library/Group Containers/com.dropbox.client.crashpad",
    "~/Library/Group Containers/com.getdropbox.dropbox.garcon",
    "~/Library/HTTPStorages/com.dropbox.DropboxMacUpdate",
    "~/Library/HTTPStorages/com.getdropbox.dropbox",
    "~/Library/LaunchAgents/com.dropbox.DropboxMacUpdate.agent.plist",
    "~/Library/Logs/Dropbox_debug.log",
    "~/Library/Preferences/com.apple.FileProvider/com.getdropbox.dropbox.fileprovider",
    "~/Library/Preferences/com.dropbox.DropboxMacUpdate.plist",
    "~/Library/Preferences/com.dropbox.DropboxMonitor.plist",
    "~/Library/Preferences/com.dropbox.tungsten.helper.plist",
    "~/Library/Preferences/com.getdropbox.dropbox.plist",
  ]
end