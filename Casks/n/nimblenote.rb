cask "nimblenote" do
  version "3.2.2"
  sha256 "4c5b2f1d8f46e3ca3f3620c092a95305ce8a09ba8632f72c870b71409a445217"

  url "https:github.comnimblenotenimblenotereleasesdownloadv#{version}nimblenote-#{version}.dmg",
      verified: "github.comnimblenotenimblenote"
  name "nimblenote"
  desc "Keyboard-driven note taking"
  homepage "https:nimblenote.app"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "nimblenote.app"

  zap trash: "~LibraryApplication Supportnimblenote"
end