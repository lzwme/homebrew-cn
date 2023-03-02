cask "bwana" do
  version "2.8.1"
  sha256 :no_check

  url "https://www.bruji.com/bwana/bwana.dmg"
  name "Bwana"
  homepage "https://www.bruji.com/bwana/"

  app "Bwana.app"

  zap trash: [
    "~/Library/Caches/Bwana",
    "~/Library/Preferences/com.bruji.bwana.plist",
  ]
end