cask "nulloy" do
  version "0.9.8.7"
  sha256 "05699212d0f3b9763362dde52ee94f7d325cbed3de316e0ab3b48dc966edc578"

  url "https:github.comnulloynulloyreleasesdownload#{version}Nulloy-#{version}-x86_64.dmg",
      verified: "github.comnulloynulloy"
  name "Nulloy"
  desc "Music player"
  homepage "https:nulloy.com"

  app "Nulloy.app"

  zap trash: "~LibrarySaved Application Statecom.nulloy.savedState"
end