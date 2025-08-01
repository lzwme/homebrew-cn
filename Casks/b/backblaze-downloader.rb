cask "backblaze-downloader" do
  version "9.0.1.772"
  sha256 :no_check

  url "https://secure.backblaze.com/mac_restore_downloader"
  name "Backblaze Downloader"
  desc "Download Backblaze restored files more reliably"
  homepage "https://www.backblaze.com/"

  livecheck do
    url "https://www.backblaze.com/computer-backup/docs/downloader-app-release-notes-mac"
    regex(/Version\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  app "BackblazeDownloader.app"

  uninstall quit: "com.backblaze.BackblazeDownloader"

  zap trash: [
    "~/Library/Logs/BackblazeDownloader",
    "~/Library/Preferences/com.backblaze.BackblazeDownloader.plist",
    "~/Library/Saved Application State/com.backblaze.BackblazeDownloader.savedState",
  ]
end