cask "signal" do
  arch arm: "arm64", intel: "x64"

  version "8.9.0"
  sha256 arm:   "812db6a58590f912beb53bf6f4fffe8508155455d92676ab39a11df01f50e8ee",
         intel: "204c521d2cbdc9e212dc2abe03e664dc969b69d5a067b62619c33273fa77417d"

  url "https://updates.signal.org/desktop/signal-desktop-mac-#{arch}-#{version}.zip"
  name "Signal"
  desc "Instant messaging application focusing on security"
  homepage "https://signal.org/"

  livecheck do
    url "https://updates.signal.org/desktop/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Signal.app"

  zap trash: [
    "~/Library/Application Support/Signal",
    "~/Library/Preferences/org.whispersystems.signal-desktop.helper.plist",
    "~/Library/Preferences/org.whispersystems.signal-desktop.plist",
    "~/Library/Saved Application State/org.whispersystems.signal-desktop.savedState",
  ]
end