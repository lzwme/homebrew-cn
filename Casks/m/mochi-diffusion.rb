cask "mochi-diffusion" do
  version "4.7"
  sha256 "bf4f1b76fca1daf01136e98841b33c54732d250d5e71cc45944292fa399c315c"

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