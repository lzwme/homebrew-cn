cask "voxql" do
  version "0.1.0"
  sha256 "d827f01af571e5924974736dc7b9e3ee07f7304442a4cf57fa06e42284dab2ad"

  url "https:github.comheptalVoxQLreleasesdownload#{version}VoxQL.qlgenerator.zip"
  name "VoxQL"
  desc "Quick Look generator for MagicaVoxel files"
  homepage "https:github.comheptalVoxQL"

  no_autobump! because: :requires_manual_review

  qlplugin "VoxQL.qlgenerator"

  # No zap stanza required
end