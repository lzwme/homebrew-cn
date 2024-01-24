cask "diffusionbee" do
  arch arm: "arm64", intel: "intel"

  version "2.5.0"
  sha256 arm:   "957a8e7040dc13a326b360037f25e6f8fa710cc185dfe9e7baac5e4980c206a5",
         intel: "88689082545d3a620ff755254402bd7887400a2fd85fc39b8343c691b17c04f5"

  url "https:github.comdivamguptadiffusionbee-stable-diffusion-uireleasesdownload#{version}DiffusionBee_MPS_#{arch}-#{version}.dmg",
      verified: "github.comdivamguptadiffusionbee-stable-diffusion-ui"
  name "Diffusion Bee"
  desc "Run Stable Diffusion locally"
  homepage "https:diffusionbee.com"

  app "DiffusionBee.app"

  zap trash: [
    "~.diffusionbee",
    "~LibraryApplication SupportDiffusionBee",
  ]
end