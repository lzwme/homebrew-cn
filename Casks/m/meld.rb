cask "meld" do
  arch arm: "arm64", intel: "x86_64"

  version "3.22.3+105"
  sha256 arm:   "aea65bbe21842e9c2e72c547df996858abbe05b2610c583f5121215556009527",
         intel: "db6be60ccf93f173851da8912b8b5cbf4a2aa6cdf419db4970c573f7fe0f7693"

  url "https:gitlab.comapiv4projects51547804packagesgenericmeld_macos#{version}Meld-#{version}_#{arch}.dmg"
  name "Meld for macOS"
  desc "Visual diff and merge tool"
  homepage "https:gitlab.comdehessellemeld_macos"

  livecheck do
    url "https:gitlab.comdehessellemeld_macos.git"
  end

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