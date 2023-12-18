cask "qlplayground" do
  version "0.2"
  sha256 "40487c1351b27a939d6383e359eea73c1a0a6b7fee00247f6954dae32540d1db"

  url "https:github.comnorio-nomuraqlplaygroundreleasesdownload#{version}qlplayground.qlgenerator-#{version}.zip"
  name "qlplayground"
  desc "QuickLook plugin for Swift files"
  homepage "https:github.comnorio-nomuraqlplayground"

  qlplugin "qlplayground.qlgenerator"

  # No zap stanza required
end