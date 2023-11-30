cask "raycast" do
  on_big_sur :or_older do
    version "1.50.0"
    sha256 "f8bbd00d06636e3fe9f154ff69ff57c0a48a90a77ae58cdcc2b285f61a170a88"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey :or_newer do
    version "1.63.0"
    sha256 "5aad10676e6f3464023a92cd8bc5c1afe8ef014bef119e6718e3aaca5f3250d4"

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