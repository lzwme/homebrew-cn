cask "altdeploy" do
  version "1.1"
  sha256 "c9f1c27e3c83022fe0fae7abe3ea825792bc799390d3fb5492f8cfb97a9d7f56"

  url "https://ghfast.top/https://github.com/pixelomer/AltDeploy/releases/download/v#{version}/AltDeploy.zip"
  name "AltDeploy"
  homepage "https://github.com/pixelomer/AltDeploy"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :high_sierra"

  app "AltDeploy.app"
end