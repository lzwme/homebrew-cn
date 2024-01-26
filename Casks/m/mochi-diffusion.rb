cask "mochi-diffusion" do
  version "5.0"
  sha256 "d0395e16c7a42d1424da7bb15fcd76641523e68224f97398a4c8d206e8f74373"

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