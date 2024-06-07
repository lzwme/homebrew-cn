cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.16"
  sha256 arm:   "05ed1d8692d051b2524f72280677150c09175cf5768017c60f98aa2b4dae7229",
         intel: "a033809c80e31134745f6a488b2d8da72bb85a4932ae8ff8ed59db28ca32726a"

  url "https:github.comheptametaproject-metareleasesdownloadv#{version}Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.comheptametaproject-meta"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https:heptabase.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end