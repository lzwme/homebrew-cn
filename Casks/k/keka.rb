cask "keka" do
  version "1.4.3"
  sha256 "c723b6e64adafdfb8bbb05a7a808facb9ad252a35a7f17d0ae3a74abafcab386"

  url "https:github.comaonezKekareleasesdownloadv#{version}Keka-#{version}.dmg",
      verified: "github.comaonezKeka"
  name "Keka"
  desc "File archiver"
  homepage "https:www.keka.io"

  livecheck do
    url "https:u.keka.iokeka.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "keka@beta"

  app "Keka.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}keka.wrapper.sh"
  binary shimscript, target: "keka"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      exec '#{appdir}Keka.appContentsMacOSKeka' '--cli' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Scriptscom.aone.keka",
    "~LibraryApplication Scriptscom.aone.keka.KekaFinderIntegration",
    "~LibraryApplication SupportKeka",
    "~LibraryCachescom.aone.keka",
    "~LibraryContainerscom.aone.keka",
    "~LibraryContainerscom.aone.keka.KekaFinderIntegration",
    "~LibraryGroup Containers*.group.com.aone.keka",
    "~LibraryPreferencescom.aone.keka.plist",
    "~LibrarySaved Application Statecom.aone.keka.savedState",
  ]
end