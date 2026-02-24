cask "owocr" do
  arch arm: "applesilicon", intel: "intel"

  version "1.25.5"
  sha256 arm:   "9b13fce4fcb36df08107f3fa0312ffecfa2b12590bd735eedf77214b55318f38",
         intel: "4ec6494abd230cb43c33ed1fe124b66ad877d55bb6e170e2656ca88a0df5d9cb"

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