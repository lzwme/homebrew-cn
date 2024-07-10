cask "apppolice" do
  version "1.1"
  sha256 "ed5a0830eb5a8cba63ab72d3c48dfd53a72d942d1a334d37b1e87c6b0fa087cf"

  url "https:github.comfuyuapppolicereleasesdownloadv#{version}apppolice.dmg"
  name "AppPolice"
  desc "App for quickly limiting CPU usage of any running process"
  homepage "https:github.comfuyuapppolice"

  app "AppPolice.app"

  uninstall quit: "com.definemac.AppPolice"

  zap trash: "~LibraryPreferencescom.definemac.AppPolice.plist"

  caveats do
    requires_rosetta
  end
end