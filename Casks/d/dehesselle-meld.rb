cask "dehesselle-meld" do
  arch arm: "arm64", intel: "x86_64"

  version "3.22.3+96"
  sha256 arm:   "0ba1b39b14a3fa78bbf779099f8b53474da977fc9e4cbfd4adac0369a095313b",
         intel: "2fbc68d5d250c5aad80ccbd3723d6758d18d38444af285b57c921c45b82d07c9"

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