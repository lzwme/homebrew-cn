cask "turtl" do
  version "0.7.2.6-sqlite-fix"
  sha256 "90085ffb3b97a3c5e6d01313fda6df4f74c7fe1b61b7c1388e54554db79c9a1a"

  url "https:github.comturtldesktopreleasesdownloadv#{version}turtl-osx.zip",
      verified: "github.comturtldesktop"
  name "turtl"
  desc "Secure collaborative notebook"
  homepage "https:turtlapp.com"

  # A tag using the stable version format is sometimes marked as "Pre-release"
  # on the GitHub releases page, so we have to use the `GithubLatest` strategy.
  # Versions with suffixes like `0.7.2.6-sqlite-fix` are also a problem when
  # using the `Git` strategy, as the suffix is compared alphabetically (so a
  # newer version may wrongly appear to be older).
  livecheck do
    url :url
    regex(^\D*?(\d+(?:\.\d+)+.*)$i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Turtl.app"

  zap trash: [
    "~LibraryApplication SupportTurtl",
    "~LibraryLogsTurtl",
    "~LibraryPreferemcescom.electron.turtl.helper.plist",
    "~LibraryPreferencescom.electron.turtl.plist",
    "~LibrarySaved Application Statecom.electron.turtl.savedState",
  ]

  caveats do
    requires_rosetta
  end
end