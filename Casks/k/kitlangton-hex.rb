cask "kitlangton-hex" do
  version "0.7.5"
  sha256 "1e653268fb3a79bd901fc5389c642610e7efa766b13f3ff28efe6ffcbf9d8f5f"

  url "https://ghfast.top/https://github.com/kitlangton/Hex/releases/download/v#{version}/Hex-#{version}.dmg",
      verified: "github.com/kitlangton/Hex/"
  name "Hex"
  desc "Voice-to-text transcription and paste tool"
  homepage "https://hex.kitlangton.com/"

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Hex.app"

  zap trash: [
    "~/Library/Application Scripts/com.kitlangton.Hex",
    "~/Library/Containers/com.kitlangton.Hex",
  ]
end