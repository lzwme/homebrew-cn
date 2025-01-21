cask "dehesselle-meld" do
  arch arm: "arm64", intel: "x86_64"

  version "3.22.3+100"
  sha256 arm:   "e2ed99dbe470837f314db06f74093ff027e270855597dd4866c8e328506e6dd9",
         intel: "c1ae72cb2f0436ff68e524227ca1e04bb0e641765e2ed6f224474d3b16b9e054"

  url "https:gitlab.comapiv4projects51547804packagesgenericmeld_macos#{version}Meld-#{version}_#{arch}.dmg"
  name "Meld for OSX"
  desc "Visual diff and merge tool"
  homepage "https:gitlab.comdehessellemeld_macos"

  livecheck do
    url "https:gitlab.comdehessellemeld_macos.git"
  end

  conflicts_with cask: "meld"
  depends_on macos: ">= :high_sierra"

  app "Meld.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}meld.wrapper.sh"
  binary shimscript, target: "meld"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Meld.appContentsMacOSMeld' "$@"
    EOS
  end

  zap trash: [
    "~.localsharemeld",
    "~LibraryApplication Supportorg.gnome.Meld",
    "~LibraryCachesorg.gnome.Meld",
    "~LibraryPreferencesorg.gnome.Meld.plist",
    "~LibrarySaved Application Stateorg.gnome.Meld.savedState",
  ]
end