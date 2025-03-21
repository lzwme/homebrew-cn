cask "opera@beta" do
  version "118.0.5461.14"
  sha256 "3432099a19c7c6eb1dc3bca05bf91d0e9487d31bdb7bed1d6d2f12fa6fbecc9f"

  url "https://get.geo.opera.com/pub/opera-beta/#{version}/mac/Opera_beta_#{version}_Setup.dmg"
  name "Opera Beta"
  desc "Web browser"
  homepage "https://www.opera.com/computer/beta"

  livecheck do
    url "https://get.geo.opera.com/pub/opera-beta/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Opera Beta.app"

  zap trash: [
    "~/Library/Application Support/com.operasoftware.OperaNext",
    "~/Library/Caches/com.operasoftware.Installer.OperaNext",
    "~/Library/Caches/com.operasoftware.OperaNext",
    "~/Library/Cookies/com.operasoftware.OperaNext.binarycookies",
    "~/Library/HTTPStorages/com.operasoftware.Installer.OperaNext",
    "~/Library/Preferences/com.operasoftware.OperaNext.plist",
    "~/Library/Saved Application State/com.operasoftware.OperaNext.savedState",
  ]
end