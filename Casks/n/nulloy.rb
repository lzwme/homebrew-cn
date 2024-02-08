cask "nulloy" do
  version "0.9.7.1"
  sha256 "4e3ecaf4728197fd52c5f752f884a479619ebbf11b784c293431005edc849aa5"

  url "https:github.comnulloynulloyreleasesdownload#{version}Nulloy-#{version}-x86_64.dmg",
      verified: "github.comnulloynulloy"
  name "Nulloy"
  desc "Music player"
  homepage "https:nulloy.com"

  app "Nulloy.app"

  zap trash: "~LibrarySaved Application Statecom.nulloy.savedState"
end