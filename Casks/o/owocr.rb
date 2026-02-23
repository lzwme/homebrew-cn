cask "owocr" do
  arch arm: "applesilicon", intel: "intel"

  version "1.25.4"
  sha256 arm:   "a232be6386a3d7feb4f4176e627d91e4c1d4d51f1218ea3eba61f7aac23b1896",
         intel: "4b083c9cd0866ed3f48e8e025cc70bc4c02d06ceffb97cc65be08873f8ec79d4"

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