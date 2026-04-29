cask "vorta" do
  arch arm: "arm", intel: "intel"

  version "0.11.4"
  sha256 arm:   "b6407f4708015a0d15d9686945e2f1f6f9641d2b156b6efea20b5b746499cf7f",
         intel: "a409346d2e85b0a6d9103ec335fc4b4bfc015dd2aebcc7d9d37a13dbe6f60490"

  url "https://ghfast.top/https://github.com/borgbase/vorta/releases/download/v#{version}/Vorta-v#{version}-#{arch}.dmg"
  name "Vorta"
  desc "Desktop Backup Client for Borg"
  homepage "https://github.com/borgbase/vorta"

  livecheck do
    url "https://borgbase.github.io/vorta/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on :macos

  app "Vorta.app"

  zap trash: "~/Library/Application Support/Vorta"

  caveats <<~EOS
    #{token} requires BorgBackup to run. If you do not need mount support, use
    the official formula:

      brew install borgbackup

    If you plan on mounting archives using macFUSE, consider using the Tap
    maintained by the Borg team:

      brew install --cask macfuse
      brew install borgbackup/tap/borgbackup-fuse
  EOS
end