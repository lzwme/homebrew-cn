cask "qlcommonmark" do
  version "1.1"
  sha256 "7778fae360f844fc17b17a4d5f8d3a01db811b0f78e174b70bea4410de2b12c7"

  url "https://ghfast.top/https://github.com/digitalmoksha/QLCommonMark/releases/download/v#{version}/QLCommonMark.qlgenerator.zip"
  name "QLCommonMark"
  desc "Quick Look plugin for CommonMark and Markdown"
  homepage "https://github.com/digitalmoksha/QLCommonMark/"

  no_autobump! because: :requires_manual_review

  qlplugin "QLCommonMark.qlgenerator"

  # No zap stanza required
end