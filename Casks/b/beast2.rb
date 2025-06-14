cask "beast2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "2.7.7"
  sha256 "4878b73a4216fd1b8a09de0ba1d4fe8793304d1053aa154078b2cb7bc7fd4d2f"

  url "https:github.comCompEvolbeast2releasesdownloadv#{version}BEAST.v#{version}.Mac.dmg",
      verified: "github.comCompEvolbeast2"
  name "BEAST2"
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https:www.beast2.org"

  livecheck do
    url "https:www.beast2.orgdownload-mac"
    regex(location=.*?BEAST[._-]v?(\d+(?:\.\d+)+)\.Mac\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  suite "BEAST #{version}"

  zap trash: [
    "~LibraryApplication SupportBEAST",
    "~LibraryPreferencesbeast.app.beauti.Beauti.plist",
    "~LibraryPreferencestracer.plist",
    "~LibraryPreferencesviz.DensiTree.plist",
    "~LibrarySaved Application Statebeastfx.app.beast.BeastMain.savedState",
  ]
end