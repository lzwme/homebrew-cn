cask "jump-desktop-connect" do
  on_sierra :or_older do
    version "6.5.39"
    sha256 "5ad7235db6cc28a2da7048636e7ea3e4f9f144e85d645d56e3a7b75b5b228b34"

    livecheck do
      skip "Legacy version"
    end
  end
  on_high_sierra :or_newer do
    version "7.1.40"
    sha256 "06a30591022d06d2f5ae580e15902a8ef1de1028819d02ee241bccd25976f8d2"

    livecheck do
      url "https://mirror.jumpdesktop.com/downloads/connect/connect-mac.xml"
      strategy :sparkle, &:short_version
    end
  end

  url "https://mirror.jumpdesktop.com/downloads/connect/JumpDesktopConnect-#{version}.dmg"
  name "Jump Desktop Connect"
  desc "Remote desktop app"
  homepage "https://jumpdesktop.com/connect/"

  auto_updates true

  pkg ".jdc.sparkle_guided.pkg"

  uninstall launchctl: [
              "application.com.p5sys.jump.connect.*",
              "com.p5sys.jump.connect.agent",
              "com.p5sys.jump.connect.service",
            ],
            signal:    ["QUIT", "com.p5sys.jump.connect"],
            pkgutil:   "com.p5sys.jump.connect",
            delete:    "/Library/Application Support/Jump Desktop/Connect/sharedconfig.plist",
            rmdir:     [
              "/Library/Application Support/Jump Desktop",
              "/Library/Application Support/Jump Desktop/Connect/",
            ]

  zap trash: [
        "~/Library/Application Support/com.p5sys.jump.connect",
        "~/Library/Caches/com.p5sys.jump.connect",
        "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.p5sys.jump.connect",
        "~/Library/Caches/Jump Desktop/jump.connect",
        "~/Library/HTTPStorages/com.p5sys.jump.connect",
        "~/Library/Preferences/com.p5sys.jump.connect.plist",
      ],
      rmdir: "~/Library/Caches/Jump Desktop"
end