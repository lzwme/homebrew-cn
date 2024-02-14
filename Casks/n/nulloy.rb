cask "nulloy" do
  version "0.9.8"
  sha256 "2e4c856953c3834cf3c7e4eff1b33d32d50d1f46a914ea70107e058bc121c2ce"

  url "https:github.comnulloynulloyreleasesdownload#{version}Nulloy-#{version}-x86_64.dmg",
      verified: "github.comnulloynulloy"
  name "Nulloy"
  desc "Music player"
  homepage "https:nulloy.com"

  app "Nulloy.app"

  zap trash: "~LibrarySaved Application Statecom.nulloy.savedState"
end