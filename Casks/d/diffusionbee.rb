cask "diffusionbee" do
  arch arm: "arm64", intel: "intel"

  version "2.5.3"
  sha256 arm:   "1c6deb9f4c745ca86631cc830951b69d5359a13bad13e87e34712617881c2977",
         intel: "2917b6beeb1dc127a8ef041e2f29a96c74a09314b6baf95ae9a2b45ad0ae5fea"

  url "https:github.comdivamguptadiffusionbee-stable-diffusion-uireleasesdownload#{version}DiffusionBee_MPS_#{arch}-#{version}.dmg",
      verified: "github.comdivamguptadiffusionbee-stable-diffusion-ui"
  name "Diffusion Bee"
  desc "Run Stable Diffusion locally"
  homepage "https:diffusionbee.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "DiffusionBee.app"

  zap trash: [
    "~.diffusionbee",
    "~LibraryApplication SupportDiffusionBee",
  ]
end