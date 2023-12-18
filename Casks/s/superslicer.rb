cask "superslicer" do
  arch arm: "_arm"

  version "2.4.58.5,220924"
  sha256 arm:   "c65d21e51ac57eb75c915ae172a642f48d63584f6bdd8a280aa2443319a66010",
         intel: "95652e91bef57c73f38c0c78f2fcc9dfce429516f5de516b5e8ac5db20d20132"

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