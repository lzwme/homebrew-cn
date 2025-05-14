cask "inkscape" do
  arch arm: "arm64", intel: "x86_64"

  version "1.4.230579"
  sha256 arm:   "118e9e23190eea1265592a8b2053f5fb67e13a55b9311b2ab284df7008a896b4",
         intel: "f0b05d5195e3aa0ba9d6d6a972f1d7f57abd876532b4d6eb02ecc98c0dcdfdbf"

  url "https:media.inkscape.orgdlresourcesfileInkscape-#{version}_#{arch}.dmg"
  name "Inkscape"
  desc "Vector graphics editor"
  homepage "https:inkscape.org"

  livecheck do
    url "https:inkscape.orgreleaseallmac-os-x"
    regex(Inkscape[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :high_sierra"

  app "Inkscape.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}inkscape.wrapper.sh"
  binary shimscript, target: "inkscape"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{staged_path}Inkscape.appContentsMacOSinkscape' "$@"
    EOS
  end

  zap trash: [
    "~.configinkscape",
    "~LibraryApplication SupportInkscape",
    "~LibraryApplication Supportorg.inkscape.Inkscape",
    "~LibraryCachesorg.inkscape.Inkscape*",
    "~LibraryPreferencesorg.inkscape.Inkscape.plist",
    "~LibrarySaved Application Stateorg.inkscape.Inkscape.savedState",
  ]
end