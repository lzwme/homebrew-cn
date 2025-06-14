cask "desktoputility" do
  version "5.3.6"
  sha256 :no_check

  url "https://sweetpproductions.com/products/desktoputility/DesktopUtility.dmg"
  name "DesktopUtility"
  desc "Quick access to useful system tasks"
  homepage "https://sweetpproductions.com/"

  livecheck do
    url "https://sweetpproductions.com/products/desktoputility/appcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "DesktopUtility.app"

  zap trash: [
    "~/Library/Application Scripts/com.sweetpproductions.DesktopUtility",
    "~/Library/Containers/com.sweetpproductions.DesktopUtility",
  ]
end