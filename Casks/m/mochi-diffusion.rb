cask "mochi-diffusion" do
  version "5.2"
  sha256 "fbb7ec461bb2f4056e4ace50758307d7a622cdc04b70ef01148f1f521386681c"

  url "https:github.comgodly-devotionMochiDiffusionreleasesdownloadv#{version}MochiDiffusion_v#{version}.dmg"
  name "Mochi Diffusion"
  desc "Run Stable Diffusion natively"
  homepage "https:github.comgodly-devotionMochiDiffusion"

  auto_updates true
  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Mochi Diffusion.app"

  zap trash: [
    "~LibraryApplication SupportMochiDiffusion",
    "~LibraryHTTPStoragescom.joshua-park.Mochi-Diffusion",
    "~LibraryPreferencescom.joshua-park.Mochi-Diffusion.plist",
  ]
end