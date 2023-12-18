cask "qlgradle" do
  version "0.0.1"
  sha256 "ea76846953ecfbd180d65167ec31cb7c316030f500a6669cd79857c03b951b63"

  url "https:github.comUrucasQLGradlereleasesdownload#{version}QLGradle.qlgenerator.zip"
  name "qlgradle"
  desc "QuickLook plugin for viewing gradle files"
  homepage "https:github.comUrucasQLGradle"

  qlplugin "QLGradle.qlgenerator"

  # No zap stanza required
end