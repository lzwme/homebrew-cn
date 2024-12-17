cask "altdeploy" do
  version "1.1"
  sha256 "c9f1c27e3c83022fe0fae7abe3ea825792bc799390d3fb5492f8cfb97a9d7f56"

  url "https:github.compixelomerAltDeployreleasesdownloadv#{version}AltDeploy.zip"
  name "AltDeploy"
  homepage "https:github.compixelomerAltDeploy"

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :high_sierra"

  app "AltDeploy.app"
end