cask "qlcommonmark" do
  version "1.1"
  sha256 "7778fae360f844fc17b17a4d5f8d3a01db811b0f78e174b70bea4410de2b12c7"

  url "https://ghfast.top/https://github.com/digitalmoksha/QLCommonMark/releases/download/v#{version}/QLCommonMark.qlgenerator.zip"
  name "QLCommonMark"
  desc "Quick Look plugin for CommonMark and Markdown"
  homepage "https://github.com/digitalmoksha/QLCommonMark/"

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "QLCommonMark.qlgenerator"

  # No zap stanza required
end