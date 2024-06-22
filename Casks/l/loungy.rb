cask "loungy" do
  version "0.1.3"
  sha256 "4d901b7dc6a02c6e51ba2af941ecd038b02308a642e330505a8f8882b07deb19"

  url "https:github.comMatthiasGrandlLoungyreleasesdownloadv#{version}Loungy_#{version}_universal.dmg"
  name "Loungy"
  desc "Application launcher"
  homepage "https:github.comMatthiasGrandlLoungy"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Loungy.app"

  zap trash: [
    "~.configloungy",
    "~LibraryApplication Supportloungy",
    "~LibraryCachesloungy",
  ]
end