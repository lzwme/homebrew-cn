cask "kindle-comic-converter" do
  arch arm: "arm", intel: "i386"

  version "10.1.2"
  sha256 arm:   "c93dbae63dd392a504e3377d45ce07a8b457b4da48a5f90ea595c79115f9cbc3",
         intel: "d8a0018ed6dff6173069b3abfae0151cc0b12a8b7aee2bdad6b67a2bab711e4e"

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