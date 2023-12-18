cask "beast2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "2.7.6"
  sha256 "ebf7d5224bd458ba905a6a9a8049baec5f15442df32d6a2ca83b6c68ab319af0"

  url "https:github.comCompEvolbeast2releasesdownloadv#{version}BEAST.v#{version}.Mac.dmg",
      verified: "github.comCompEvolbeast2"
  name "BEAST2"
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https:www.beast2.org"

  livecheck do
    url "https:www.beast2.orgdownload-mac"
    regex(location=.*?BEAST[._-]v?(\d+(?:\.\d+)+)\.Mac\.dmgi)
  end

  suite "BEAST #{version}"

  zap trash: [
    "~LibraryApplication SupportBEAST",
    "~LibraryPreferencesbeast.app.beauti.Beauti.plist",
    "~LibraryPreferencestracer.plist",
    "~LibraryPreferencesviz.DensiTree.plist",
    "~LibrarySaved Application Statebeastfx.app.beast.BeastMain.savedState",
  ]
end