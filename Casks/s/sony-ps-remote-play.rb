cask "sony-ps-remote-play" do
  version "8.0.0"
  sha256 :no_check

  url "https://remoteplay.dl.playstation.net/remoteplay/module/mac/RemotePlayInstaller.pkg"
  name "PS Remote Play"
  desc "Application to control your PlayStation 4 or PlayStation 5"
  homepage "https://remoteplay.dl.playstation.net/remoteplay/lang/en/"

  livecheck do
    url "https://remoteplay.dl.playstation.net/remoteplay/module/mac/rp-version-mac.json"
    strategy :json do |json|
      json["version"]
    end
  end

  pkg "RemotePlayInstaller.pkg"

  uninstall pkgutil: "com.playstation.RemotePlay.pkg"

  zap trash: [
    "~/Library/Application Support/Sony Corporation/PS Remote Play",
    "~/Library/Application Support/Sony Corporation/PS4 Remote Play",
    "~/Library/Caches/com.playstation.RemotePlay",
    "~/Library/Cookies/com.playstation.RemotePlay.binarycookies",
    "~/Library/HTTPStorages/com.playstation.RemotePlay.binarycookies",
    "~/Library/Preferences/com.playstation.RemotePlay.plist",
    "~/Library/WebKit/com.playstation.RemotePlay",
  ]
end