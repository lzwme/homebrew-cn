cask "openkey" do
  version "2.0.5"
  sha256 "0551e0b73f2aff1c75098124f348ea871b8a7233f8c407875ceb69d7b8f84b1c"

  url "https://ghfast.top/https://github.com/tuyenvm/OpenKey/releases/download/#{version}/OpenKey#{version}.dmg"
  name "OpenKey"
  desc "Vietnamese input system"
  homepage "https://github.com/tuyenvm/OpenKey/"

  no_autobump! because: :requires_manual_review

  app "OpenKey.app"

  zap trash: [
    "~/Library/Caches/com.tuyenmai.openkey",
    "~/Library/HTTPStorages/com.tuyenmai.openkey",
    "~/Library/Preferences/com.tuyenmai.openkey.plist",
  ]
end