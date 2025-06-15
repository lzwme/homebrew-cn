cask "polypad" do
  version "1.3.0"
  sha256 "8640fca759485073b686d76fdda6c8c532bce480c60ea7516947aa8799420e0d"

  url "https:downloads.mattebot.copolypadmacPolypad-#{version}.dmg",
      verified: "downloads.mattebot.copolypadmac"
  name "Polypad"
  desc "Scriptable Textpad for Developers"
  homepage "https:polypad.io"

  no_autobump! because: :requires_manual_review

  # Downloads are no longer available, have been missing since April 2024
  # https:github.commattebotPolypadissues7
  disable! date: "2024-09-07", because: :no_longer_available

  app "Polypad.app"

  zap trash: "~LibraryApplication SupportPolypad"
end