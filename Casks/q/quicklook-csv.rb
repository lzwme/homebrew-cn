cask "quicklook-csv" do
  version "1.3"
  sha256 "e052e89f8003aed08bb2058e3fb3335ac0a5cdaa0171bfb23b762976e095ef5b"

  url "https:github.comp2quicklook-csvreleasesdownload#{version}QuickLookCSV-#{version}.dmg"
  name "QuickLookCSV"
  desc "Quick Look plugin for CSV files"
  homepage "https:github.comp2quicklook-csv"

  qlplugin "QuickLookCSV.qlgenerator"

  # No zap stanza required
end