cask "raycast" do
  on_big_sur :or_older do
    version "1.50.0"
    sha256 "f8bbd00d06636e3fe9f154ff69ff57c0a48a90a77ae58cdcc2b285f61a170a88"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey :or_newer do
    version "1.71.2"
    sha256 "0729fa42620a688145f7fe7f46ed0a2beba80667289c1db4fa7ea10d4c5aab2a"

    livecheck do
      url :url
      regex(/Raycast[._-]v?(\d+(?:\.\d+)+)(?:[._-](\h+))[._-]universal\.dmg/i)
      strategy :header_match
    end
  end

  url "https://releases.raycast.com/releases/#{version}/download?build=universal"
  name "Raycast"
  desc "Control your tools with a few keystrokes"
  homepage "https://raycast.com/"

  auto_updates true

  app "Raycast.app"

  uninstall quit: "com.raycast.macos"

  zap trash: [
    "~/.config/raycast",
    "~/Library/Application Support/com.raycast.macos",
    "~/Library/Caches/com.raycast.macos",
    "~/Library/Caches/SentryCrash/Raycast",
    "~/Library/Cookies/com.raycast.macos.binarycookies",
    "~/Library/HTTPStorages/com.raycast.macos",
    "~/Library/Preferences/com.raycast.macos.plist",
  ]
end