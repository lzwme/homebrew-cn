cask "magicavoxel" do
  version "0.99.6.2"
  sha256 "4ee661e41da07f8c2b2b1c916bd1e18f7c5229900f30467eeea73ad74e861226"

  url "https:github.comephtracyephtracy.github.ioreleasesdownload#{version.major_minor_patch}MagicaVoxel-#{version}-macos-10.15.zip",
      verified: "github.comephtracyephtracy.github.io"
  name "MagicaVoxel"
  desc "8-bit 3D voxel editor and interactive path tracing renderer"
  homepage "https:ephtracy.github.io"

  livecheck do
    skip "No reliable way to get version info"
  end

  suite staged_path, target: "MagicaVoxel"

  zap trash: [
    "~LibraryPreferencesEPH.MagicaVoxel.plist",
    "~LibrarySaved Application StateEPH.MagicaVoxel.savedState",
  ]
end