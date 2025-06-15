cask "ttscoff-mmd-quicklook" do
  version "1.2"
  sha256 "6370fa8d98e627d83fe70e9bc5bd400bd7b6b68257a40bf33bb70df5d12935c1"

  url "https:github.comttscoffMMD-QuickLookreleasesdownload#{version}MMD-QuickLook#{version}.zip"
  name "MMD-QuickLook"
  desc "Quick Look plugin for viewing MultiMarkdown"
  homepage "https:github.comttscoffmmd-quicklook"

  no_autobump! because: :requires_manual_review

  qlplugin "MultiMarkdown QuickLook.qlgenerator"

  # No zap stanza required
end