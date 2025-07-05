cask "gyroflow" do
  version "1.6.1"
  sha256 "3c9ae9fbc8de95ea02e87891159711f98920d15014cc01bb03ff112226eb1627"

  url "https://ghfast.top/https://github.com/gyroflow/gyroflow/releases/download/v#{version}/Gyroflow-mac-universal.dmg",
      verified: "github.com/gyroflow/gyroflow/"
  name "Gyroflow"
  desc "Video stabilization using gyroscope data"
  homepage "https://gyroflow.xyz/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Gyroflow.app"

  zap trash: "~/Library/Caches/Gyroflow"
end