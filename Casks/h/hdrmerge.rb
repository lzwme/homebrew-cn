cask "hdrmerge" do
  version "0.5.0"
  sha256 "7a87751b8f5aa005e7f41fcc009230f3db3f38cde66a3919184d66dd107518bf"

  url "https:github.comjcelayahdrmergereleasesdownloadv#{version}HDRMerge.dmg",
      verified: "github.comjcelayahdrmerge"
  name "HDRMerge"
  desc "Creates raw images with extended dynamic range"
  homepage "https:jcelaya.github.iohdrmerge"

  deprecate! date: "2024-07-12", because: :unmaintained

  app "HDRMerge.app"
  binary "#{appdir}HDRMerge.appContentsMacOShdrmerge"

  zap trash: "~LibraryPreferencescom.j-celaya.HdrMerge.plist"

  caveats do
    requires_rosetta
  end
end