cask "frescobaldi" do
  arch intel: "-Intel"

  version "4.0.3"
  sha256 arm:   "6242cf4a2ec783751f12d1afe6170f582a9be22a413790fc9e1708fdd3b0c1ce",
         intel: "581f4942cb2e5d8bac37725623e03321fe545eefbabaaf4a68464033bfe2c1f9"

  url "https:github.comfrescobaldifrescobaldireleasesdownloadv#{version}Frescobaldi-#{version}#{arch}.dmg",
      verified: "github.comfrescobaldifrescobaldi"
  name "Frescobaldi"
  desc "LilyPond editor"
  homepage "https:frescobaldi.org"

  # Some GitHub tags do not follow standard versioning pattern
  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Frescobaldi.app"

  zap trash: "~LibraryPreferencesorg.frescobaldi.frescobaldi.plist"
end