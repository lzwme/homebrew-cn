cask "futubull@legacy" do
  version "15.22.12108"
  sha256 "018c5ea27d403c6903db68dc1162b9a381daf8da6ed232b657b8d3f35b6aaa5f"

  url "https://softwaredownload.futunn.com/FTNN_legacy_#{version}_Website.dmg",
      user_agent: :fake,
      referer:    "https://www.futunn.com/"
  name "Futubull Legacy For Mac"
  name "版富途牛牛 Mac 桌面经典版"
  desc "Futubull trading application"
  homepage "https://www.futunn.com/"

  livecheck do
    url "https://www.futunn.com/api/futunn/download/fetch-lasted-link?clientType=11&isNext=0"
    regex(/FTNN_legacy[._-]v?(\d+(?:\.\d+)+)[._-]Website\.dmg/i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "FutuNiuniu.app"

  uninstall quit: "cn.futu.niuniu"

  zap trash: [
    "~/Library/Application Scripts/cn.futu.Niuniu",
    "~/Library/Containers/cn.futu.Niuniu",
    "~/Library/Containers/cn.futu.niuniu.nx",
  ]
end