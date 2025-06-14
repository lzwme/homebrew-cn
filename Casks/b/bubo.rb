cask "bubo" do
  version "1.0"
  sha256 :no_check

  url "https:jguice.s3.amazonaws.commac-bt-headset-fix-betabubo.app.zip",
      verified: "jguice.s3.amazonaws.commac-bt-headset-fix-beta"
  name "Bubo"
  name "Spotify Bluetooth Headset Listener"
  desc "Fixes broken bluetooth headset control"
  homepage "https:github.comjguicemac-bt-headset-fix"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"

  app "bubo.app"
end