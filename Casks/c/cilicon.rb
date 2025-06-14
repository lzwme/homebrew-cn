cask "cilicon" do
  version "2.2.3"
  sha256 "5e9f4524e77688105432217c167c49edd8c8629c05e73379701c2974aceb3a7c"

  url "https:github.comtraderepublicCiliconreleasesdownloadv#{version}Cilicon.zip"
  name "Cilicon"
  desc "Self-Hosted ephemeral CI on Apple Silicon"
  homepage "https:github.comtraderepublicCilicon"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "Cilicon.app"

  zap trash: [
    "~.cilicon.yml",
    "~cilicon.yml",
  ]
end