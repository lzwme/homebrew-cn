cask "keycast" do
  version "1.1"
  sha256 "61c382ee6aafa393470b86a833a93ecbe1ce91a5665f273109631733facdb727"

  url "https://ghfast.top/https://github.com/cho45/KeyCast/releases/download/v#{version}/KeyCast.dmg"
  name "KeyCast"
  desc "Record keystroke for screencast"
  homepage "https://github.com/cho45/KeyCast"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "KeyCast.app"
end