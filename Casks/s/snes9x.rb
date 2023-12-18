cask "snes9x" do
  version "1.62.3"
  sha256 "d2e71fad2c2ebdcf6b31a91d0a7f60e9df1799a1454a6b29bc2a089b9022cec7"

  url "https:github.comsnes9xgitsnes9xreleasesdownload#{version}snes9x-#{version}-Mac.zip",
      verified: "github.comsnes9xgitsnes9x"
  name "Snes9x"
  desc "Video game console emulator"
  homepage "https:www.snes9x.com"

  app "Snes9x.app"

  zap trash: [
    "~LibraryApplication SupportSnes9x",
    "~LibraryPreferencescom.snes9x.macos.snes9x.plist",
    "~LibrarySaved Application Statecom.snes9x.macos.snes9x.savedState",
  ]
end