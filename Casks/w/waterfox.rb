cask "waterfox" do
  version "6.5.9"
  sha256 "913f70d73fc536c19b22fef2fea7f6e5ef4a2b17745c353348d2c47c81ec707a"

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