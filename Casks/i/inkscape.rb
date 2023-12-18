cask "inkscape" do
  arch arm: "arm64", intel: "x86_64"

  version "1.3.2"
  sha256 arm:   "d3b182d1f6804f01eb13195325c5376ee7147561f2cfd59c3920c34f0e0858d8",
         intel: "7c3347c274a5f8c9fb8c076b3d745e509b400e21127067edfa77adf4ca40834e"

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