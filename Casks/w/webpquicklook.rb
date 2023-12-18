cask "webpquicklook" do
  version "1.0"
  sha256 :no_check

  url "https:raw.githubusercontent.comeminWebPQuickLookmasterWebpQuickLook.tar.gz",
      verified: "raw.githubusercontent.comeminWebPQuickLook"
  name "WebPQuickLook"
  desc "QuickLook plugin for webp files"
  homepage "https:github.comeminWebPQuickLook"

  livecheck do
    url :url
    strategy :extract_plist
  end

  qlplugin "WebpQuickLook.qlgenerator"

  # No zap stanza required
end