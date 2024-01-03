cask "mochi-diffusion" do
  version "4.7.1"
  sha256 "1d0c40252e9702c816f91ec1da674e86b2eafe4cd74308a4e9d666e5db92c3c2"

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