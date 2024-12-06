cask "timelapze" do
  version "1.2.2"
  sha256 "5ab0fad611d6b627a10ee4db673fd74bbca1296e6b15ea152eabc8ca88a10187"

  url "https:github.comwkaisertexasScreenTimeLapsereleasesdownloadv#{version}TimeLapze.zip"
  name "TimeLapze"
  desc "Record screen and camera time lapses in a menu bar interface"
  homepage "https:github.comwkaisertexasScreenTimeLapse"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "TimeLapze.app"

  uninstall quit: "com.smartservices.TimeLapze"

  zap trash: [
    "~LibraryApplication Scriptscom.smartservices.TimeLapze",
    "~LibraryContainerscom.smartservices.TimeLapze",
    "~LibraryPreferencescom.smartservices.TimeLapze.plist",
  ]
end