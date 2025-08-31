cask "bili-downloader" do
  version "1.7.2"
  sha256 "aacc58eb79d64437b15882502190be17e68656999af6efcc81fa831973115bfa"

  url "https://ghfast.top/https://github.com/JimmyLiang-lzm/biliDownloader_GUI/releases/download/V#{version}/BiliDownloader_for_MacOS_X.dmg"
  name "BiliDownloader"
  desc "BiliBili media downloader"
  homepage "https://github.com/JimmyLiang-lzm/biliDownloader_GUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "biliDownloader_GUI.app"

  zap trash: "~/Library/Saved Application State/biliDownloader_GUI.savedState"

  caveats do
    requires_rosetta
  end
end