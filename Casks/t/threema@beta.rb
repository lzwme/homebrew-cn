cask "threema@beta" do
  arch arm: "arm64", intel: "x64"

  version "2.0-beta40"
  sha256 arm:   "1be39ff627a1a9bf708091ea4e52e2aa29d2b788f780199236220c33f921afa8",
         intel: "ccc92f9b46ef2f5273712b3356389ea5efe4b3d217434548cea8ea41a4fa9087"

  url "https://releases.threema.ch/desktop/#{version}/threema-desktop-v#{version}-macos-#{arch}.dmg"
  name "Threema"
  desc "End-to-end encrypted instant messaging application"
  homepage "https://threema.ch/download-md"

  livecheck do
    url "https://threema.ch/en/download-md"
    regex(/href=.*?threema[._-]desktop[._-]v?(\d+(?:(?:[.-]|(beta))+\d+)+)[._-]macos[._-]#{arch}\.dmg/i)
  end

  depends_on macos: ">= :catalina"

  app "Threema Beta.app"

  zap trash: [
    "~/Library/Application Support/ThreemaDesktop",
    "~/Library/Preferences/ch.threema.threema-desktop.plist",
    "~/Library/Saved Application State/ch.threema.threema-desktop.savedState",
  ]
end