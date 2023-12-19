cask "bubo" do
  version "1.0"
  sha256 :no_check

  url "https:jguice.s3.amazonaws.commac-bt-headset-fix-betabubo.app.zip",
      verified: "jguice.s3.amazonaws.commac-bt-headset-fix-beta"
  name "Bubo"
  name "Spotify Bluetooth Headset Listener"
  desc "Fixes broken bluetooth headset control"
  homepage "https:github.comjguicemac-bt-headset-fix"

  deprecate! date: "2023-12-17", because: :discontinued

  depends_on macos: ">= :sierra"

  app "bubo.app"
end