cask "dexed" do
  version "0.9.7"
  sha256 "b4357157fbdfc453c56ea02799978571624d8506c4dd728150f85ead798f3330"

  url "https:github.comasb2m10dexedreleasesdownloadv#{version}dexed-#{version}-macos.zip",
      verified: "github.comasb2m10dexed"
  name "Dexed"
  desc "DX7 FM synthesiser"
  homepage "https:asb2m10.github.iodexed"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "dexed-macOS-#{version}.pkg"

  uninstall pkgutil: [
              "com.digitalsuburban.dexed.app.pkg",
              "com.digitalsuburban.dexed.clap.pkg",
              "com.digitalsuburban.dexed.component.pkg",
              "com.digitalsuburban.dexed.vst3.pkg",
            ],
            delete:  "ApplicationsDexed.app"

  zap trash: [
    "privatevardbreceiptscom.digitalsuburban.dexed.*",
    "~LibraryApplication SupportDexed.settings",
    "~LibrarySaved Application Statecom.digitalsuburban.Dexed.savedState",
  ]
end