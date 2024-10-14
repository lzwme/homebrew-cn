cask "inkscape" do
  arch arm: "arm64", intel: "x86_64"

  version "1.4.028868"
  sha256 arm:   "c2d89809ad8d85021e7784e72e28aee2231b0b8675ec3ede3e6fb9f1ffedb4b3",
         intel: "e3f968e131e5c3577ee21809da487eafe2a9b42370e2bf408e5811b6f965912e"

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