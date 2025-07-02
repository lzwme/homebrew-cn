cask "keka" do
  version "1.5.2"
  sha256 "ff8ff2bd094d40c8322ac50e37883cb4be6ffd284aecc280cfe7486145eb5579"

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
    "~LibraryApplication Scripts*.group.com.aone.keka",
    "~LibraryApplication Scriptscom.aone.keka",
    "~LibraryApplication Scriptscom.aone.keka.KekaFinderIntegration",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.aone.keka.sfl*",
    "~LibraryApplication SupportKeka",
    "~LibraryCachescom.aone.keka",
    "~LibraryContainerscom.aone.keka",
    "~LibraryContainerscom.aone.keka.KekaFinderIntegration",
    "~LibraryGroup Containers*.group.com.aone.keka",
    "~LibraryPreferencescom.aone.keka.plist",
    "~LibrarySaved Application Statecom.aone.keka.savedState",
  ]
end