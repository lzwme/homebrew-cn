cask "kindle-comic-converter" do
  arch arm: "arm", intel: "i386"

  version "10.1.0"
  sha256 arm:   "e61909ea9428cda37ce9dd1c3ff91cc543f26f7d803429d4c1fdca778f502f29",
         intel: "58699b9484cac5126158d43bd9359bb94529fb607c8ecdd1602e76057419299c"

  on_arm do
    depends_on macos: ">= :big_sur"
  end
  on_intel do
    depends_on macos: ">= :catalina"
  end

  url "https://ghfast.top/https://github.com/ciromattia/kcc/releases/download/v#{version}/kcc_macos_#{arch}_#{version}.dmg"
  name "Kindle Comic Converter"
  name "KCC"
  desc "Comic and manga converter for ebook readers"
  homepage "https://github.com/ciromattia/kcc"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Kindle Comic Converter.app"

  zap trash: "~/Library/Preferences/com.kindlecomicconverter.KindleComicConverter.plist"
end