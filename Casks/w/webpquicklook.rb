cask "webpquicklook" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://raw.githubusercontent.com/emin/WebPQuickLook/master/WebpQuickLook.tar.gz",
      verified: "raw.githubusercontent.com/emin/WebPQuickLook/"
  name "WebPQuickLook"
  desc "Quick Look plugin for webp files"
  homepage "https://github.com/emin/WebPQuickLook"

  livecheck do
    url :url
    strategy :extract_plist
  end

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "WebpQuickLook.qlgenerator"

  # No zap stanza required
end