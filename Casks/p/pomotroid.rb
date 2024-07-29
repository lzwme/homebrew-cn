cask "pomotroid" do
  version "0.13.0"
  sha256 "fab1a8598490db267639609b42312a8947ee2de075164935d0eba60c57790788"

  url "https:github.comSplodepomotroidreleasesdownloadv#{version}pomotroid-#{version}-macos.dmg"
  name "Pomotroid"
  desc "Timer application"
  homepage "https:github.comSplodepomotroid"

  app "Pomotroid.app"

  zap trash: [
    "~LibraryApplication Supportpomotroid",
    "~LibraryPreferencescom.splode.pomotroid.plist",
    "~LibrarySaved Application Statecom.splode.pomotroid.savedState",
  ]

  caveats do
    requires_rosetta
  end
end