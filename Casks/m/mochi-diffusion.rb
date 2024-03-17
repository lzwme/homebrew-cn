cask "mochi-diffusion" do
  version "5.1"
  sha256 "2a09a8f4d3329acdbea227de6952cf6ad89875c1ffea54107d6323e43d02283f"

  url "https:github.comgodly-devotionMochiDiffusionreleasesdownloadv#{version}MochiDiffusion_v#{version}.dmg"
  name "Mochi Diffusion"
  desc "Run Stable Diffusion natively"
  homepage "https:github.comgodly-devotionMochiDiffusion"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Mochi Diffusion.app"

  zap trash: [
    "~LibraryApplication SupportMochiDiffusion",
    "~LibraryHTTPStoragescom.joshua-park.Mochi-Diffusion",
    "~LibraryPreferencescom.joshua-park.Mochi-Diffusion.plist",
  ]
end