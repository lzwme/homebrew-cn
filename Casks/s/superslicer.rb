cask "superslicer" do
  arch arm: "_arm"

  version "2.5.59.13,240701"
  sha256 arm:   "5e1358d36c4948177aca4caaccea9532cf357517ec9464284d9126f0a65677bb",
         intel: "37ead99e2bbce30cdf411b50dc9cf41f70acaa8e9f8371ed5b8f5c7ad43b3a13"

  url "https:github.comsupermerillSuperSlicerreleasesdownload#{version.csv.first}SuperSlicer_#{version.csv.first}_macos#{arch}_#{version.csv.second}.dmg"
  name "SuperSlicer"
  desc "Convert 3D models into G-code instructions or PNG layers"
  homepage "https:github.comsupermerillSuperSlicer"

  livecheck do
    skip "Requires checking separate GitHub release asset list HTML"
  end

  depends_on formula: "zstd"

  app "SuperSlicer.app"

  zap trash: "~LibraryApplication SupportSuperSlicer"
end