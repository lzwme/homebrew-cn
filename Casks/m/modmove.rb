cask "modmove" do
  version "1.1.1"
  sha256 "81b9cd96050b6bffecccb1ec6ef590a4fc0225c86e96de0a67a482b80c241bf7"

  url "https:github.comkeithmodmovereleasesdownload#{version}ModMove.app.zip"
  name "ModMove"
  desc "Utility to moveresize windows using modifiers and the mouse"
  homepage "https:github.comkeithmodmove"

  no_autobump! because: :requires_manual_review

  app "ModMove.app"

  # No zap stanza required
end