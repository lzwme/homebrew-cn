cask "dexed" do
  version "0.9.8"
  sha256 "3be32f98e56b40d9555a4069368c7307b8bae3368459bb087cf6195ae7538704"

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