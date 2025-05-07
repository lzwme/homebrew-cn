cask "waterfox" do
  version "6.5.7"
  sha256 "20d61b45b7f22a19494d59293f5cd56bf82338ce992add763b16fe92b7f416c1"

  url "https:cdn1.waterfox.netwaterfoxreleases#{version}Darwin_x86_64-aarch64Waterfox%20#{version}.dmg"
  name "Waterfox"
  desc "Web browser"
  homepage "https:www.waterfox.net"

  livecheck do
    url "https:cdn1.waterfox.netwaterfoxreleaseslatestmacos"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Waterfox.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}waterfox.wrapper.sh"
  binary shimscript, target: "waterfox"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Waterfox.appContentsMacOSwaterfox' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.mozilla.waterfox.sfl*",
    "~LibraryApplication SupportWaterfox",
    "~LibraryCachesWaterfox",
    "~LibraryPreferencesorg.waterfoxproject.waterfox.plist",
  ]
end