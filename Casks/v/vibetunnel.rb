cask "vibetunnel" do
  version "1.0.0-beta.15"
  sha256 "4676ad1d03fbc19fb13f5904ace365c1ccffa4718cc01a1b896b5014ee323a3e"

  url "https://ghfast.top/https://github.com/amantus-ai/vibetunnel/releases/download/v#{version}/VibeTunnel-#{version}.dmg",
      verified: "github.com/amantus-ai/vibetunnel/"
  name "VibeTunnel"
  desc "Turn any browser into your terminal"
  homepage "https://vibetunnel.sh/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)*(?:-beta\.\d+)?)$/i)
  end

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "VibeTunnel.app"
  binary "#{appdir}/VibeTunnel.app/Contents/Resources/vt"

  zap trash: [
    "~/Library/Application Support/VibeTunnel",
    "~/Library/Caches/com.amantus.vibetunnel",
    "~/Library/Preferences/com.amantus.vibetunnel.plist",
    "~/Library/Saved Application State/com.amantus.vibetunnel.savedState",
  ]
end