cask "deviceinfo" do
  version "1.0"
  sha256 "0387e3d5a12027d807bc8e84d11c8ae062fef56ca1bbcbba65e0ecc83989ed5e"

  url "https:github.comCoreNionDeviceInforeleasesdownloadv#{version}DeviceInfo.dmg"
  name "DeviceInfo"
  desc "Display device information"
  homepage "https:github.comCoreNionDeviceInfo"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :sierra"

  app "DeviceInfo.app"
end