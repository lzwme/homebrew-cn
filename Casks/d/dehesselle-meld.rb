cask "dehesselle-meld" do
  arch arm: "arm64", intel: "x86_64"

  version "3.22.2+68"
  sha256 arm:   "5c21f6a4c5aad410e515484740b461fefdfa231635326c69a844938b4dfe37b5",
         intel: "a91bb4802db1d068475bf984d75a2174221a9f9f3ddfb690a080c7935a955554"

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