cask "ntfstool" do
  version "3.5.1"
  sha256 "3d910b02c9267d9d48aa031f9ea1d1c39af3171d9f012b1fa421e6af382a58ad"

  url "https:github.comntfstoolntfstoolreleasesdownload#{version}ntfstool#{version}.zip"
  name "NTFSTool"
  desc "Utility that provides NTFS read and write support"
  homepage "https:github.comntfstoolntfstool"

  auto_updates true

  app "Ntfstool.app"

  zap trash: "~.ntfstool"
end