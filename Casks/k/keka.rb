cask "keka" do
  version "1.4.5"
  sha256 "6757548378ed596cdef669cdb582607a8f82e7df3aaf305c76ead2688504efc4"

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