cask "owocr" do
  arch arm: "applesilicon", intel: "intel"

  version "1.26.0"
  sha256 arm:   "3375c4eed8da979ed3c7bc91e11ba921216167559a29a5347c7e0c67ee8c080e",
         intel: "b0e655dfe26fa929d0d82399182c2f804bf9ec437bb3a701cf37266a565a939a"

  url "https://ghfast.top/https://github.com/AuroraWright/owocr/releases/download/#{version}/owocr-mac_#{arch}.dmg"
  name "OwOCR"
  desc "Optical character recognition for Japanese text"
  homepage "https://github.com/AuroraWright/owocr/"

  app "OwOCR.app"

  zap trash: [
    "~/Library/Application Support/com.aury.owocr",
    "~/Library/Caches/com.aury.owocr",
  ]
end