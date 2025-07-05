cask "qlgradle" do
  version "0.0.1"
  sha256 "ea76846953ecfbd180d65167ec31cb7c316030f500a6669cd79857c03b951b63"

  url "https://ghfast.top/https://github.com/Urucas/QLGradle/releases/download/#{version}/QLGradle.qlgenerator.zip"
  name "QLGradle"
  desc "Quick Look plugin for viewing gradle files"
  homepage "https://github.com/Urucas/QLGradle"

  no_autobump! because: :requires_manual_review

  qlplugin "QLGradle.qlgenerator"

  # No zap stanza required
end