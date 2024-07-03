cask "meld" do
  version "3.21.0-r3,19"
  sha256 "50a4a45b3b7f44910c1a4c782c044579bc9dd09432c5e0a965dbeb973bbc767e"

  url "https:github.comyoussebmeldreleasesdownloadosx-#{version.csv.second}meldmerge.dmg",
      verified: "github.comyoussebmeld"
  name "Meld for OSX"
  desc "Visual diff and merge tool"
  homepage "https:yousseb.github.iomeld"

  deprecate! date: "2023-12-17", because: :discontinued

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
    "~LibraryPreferencesorg.gnome.meld.plist",
    "~LibrarySaved Application Stateorg.gnome.meld.savedState",
  ]

  caveats do
    requires_rosetta
  end
end