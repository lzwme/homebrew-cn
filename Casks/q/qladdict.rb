cask "qladdict" do
  version "1.3.0"
  sha256 "9342a65b103ab4f71b21f4094f0f9ad8c48b38e976fc4d10cf2995936531e551"

  url "https://ghfast.top/https://github.com/tattali/QLAddict/releases/download/#{version}/QLAddict.qlgenerator.#{version}.zip"
  name "QLAddict"
  desc "Quick Look plugin for subtitle (.srt) files"
  homepage "https://github.com/tattali/QLAddict/"

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "QLAddict.qlgenerator"

  # No zap stanza required
end