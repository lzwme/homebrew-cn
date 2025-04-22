cask "startupfolder" do
  version "1.1.5"
  sha256 "fce3ca7a77541093b26433fca036d5ea04de7f5d7c42ac54c639b30aa1c13aae"

  url "https://files.lowtechguys.com/releases/StartupFolder-#{version}.dmg"
  name "Startup Folder"
  desc "Run anything at startup by simply placing it in a special folder"
  homepage "https://lowtechguys.com/startupfolder"

  livecheck do
    url "https://files.lowtechguys.com/startupfolder/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "StartupFolder.app"

  uninstall launchctl:  "com.lowtechguys.StartupFolder",
            quit:       "com.lowtechguys.StartupFolder",
            login_item: ["com.lowtechguys.StartupFolder", "StartupFolder.app"]

  zap trash: [
        "~/Library/Caches/startup-folder-favicons",
        "~/Library/HTTPStorages/com.lowtechguys.StartupFolder",
        "~/Library/Preferences/com.lowtechguys.StartupFolder.plist",
        "~/Library/Saved Application State/com.lowtechguys.StartupFolder.savedState",
      ],
      rmdir: "~/Startup"
end