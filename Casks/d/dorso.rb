cask "dorso" do
  version "1.9.2"
  sha256 "1fd31a8b7b26af750a7fbcf57bd9ef88fd0793b35a38d07b9979afb44c29f5b8"

  url "https://ghfast.top/https://github.com/tldev/dorso/releases/download/v#{version}/Dorso-v#{version}.dmg"
  name "Dorso"
  desc "Posture monitoring app"
  homepage "https://github.com/tldev/dorso"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Dorso.app"

  zap trash: "~/Library/Preferences/com.thelazydeveloper.posturr.plist"
end