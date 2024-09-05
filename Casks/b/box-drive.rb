cask "box-drive" do
  version "2.40.345"
  sha256 "203493ec8aedce5502d36464e02665a1d9e01ad0aed3d86468b3df12280ffb1c"

  url "https://e3.boxcdn.net/desktop/releases/mac/BoxDrive-#{version}.pkg",
      verified: "e3.boxcdn.net/desktop/releases/mac/"
  name "Box Drive"
  desc "Client for the Box cloud storage service"
  homepage "https://www.box.com/drive"

  livecheck do
    url "https://cdn07.boxcdn.net/Autoupdate5.json"
    strategy :json do |json|
      json.dig("mac", "free", "version")
    end
  end

  auto_updates true
  conflicts_with cask: "box-sync"
  depends_on macos: ">= :el_capitan"

  pkg "BoxDrive-#{version}.pkg"

  uninstall launchctl: "com.box.desktop.helper",
            quit:      [
              "com.box.Box-Local-Com-Server",
              "com.box.desktop",
              "com.box.desktop.findersyncext",
              "com.box.desktop.helper",
              "com.box.desktop.ui",
            ],
            script:    "/Library/Application Support/Box/uninstall_box_drive",
            pkgutil:   "com.box.desktop.installer.*"

  zap trash: [
    "~/.Box_*",
    "~/Library/Application Support/Box/Box",
    "~/Library/Application Support/FileProvider/com.box.desktop.boxfileprovider",
    "~/Library/Containers/com.box.desktop.findersyncext",
    "~/Library/Logs/Box/Box",
    "~/Library/Preferences/com.box.desktop.plist",
    "~/Library/Preferences/com.box.desktop.ui.plist",
  ]
end