cask "ipremoteutility" do
  version "1.9.3"
  sha256 "3523153ffbe2c4d5bb47e703c70db6880f8da2f2740d4521e5407d9d4decf380"

  url "https://www.flandersscientific.com/ip-remote/release/IPRemoteUtility-#{version}-macOSX.zip"
  name "Flanders IP Remote Utility"
  desc "Management of Flanders Scientific hardware"
  homepage "https://www.flandersscientific.com/ip-remote/"

  livecheck do
    url :homepage
    regex(/href=.*?IPRemoteUtility[._-]v?(\d+(?:\.\d+)+)[._-]macOSX\.zip/i)
  end

  depends_on macos: ">= :high_sierra"
  container nested: "IPRemoteUtility-#{version}-macOSX/IPRemoteUtility-#{version}.dmg"

  app "IPRemoteUtility.app"

  zap trash: [
    "~/Library/Application Support/FlandersScientific/IPRemoteUtility",
    "~/Library/Caches/FlandersScientific/IPRemoteUtility",
    "~/Library/Preferences/com.flandersscientific.IPRemoteUtility.plist",
  ]
end