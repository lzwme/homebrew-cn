cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.7.9"
  sha256 arm:   "394ead202db5b9e6a3ee2d7bfff320da24f2800f0cf7869f33c6381fedb86fc2",
         intel: "d27d7eb569bd7935034bb9ab9c74b610f8b268bdbd880d7745db73ae9b12b3a7"

  url "https:github.comtagspacestagspacesreleasesdownloadv#{version}tagspaces-mac-#{arch}-#{version}.dmg",
      verified: "github.comtagspacestagspaces"
  name "TagSpaces"
  desc "Offline, open-source, document manager with tagging support"
  homepage "https:www.tagspaces.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "TagSpaces.app"

  zap trash: [
    "~LibraryApplication SupportTagSpaces",
    "~LibraryPreferencesorg.tagspaces.desktopapp.plist",
    "~LibrarySaved Application Stateorg.tagspaces.desktopapp.savedState",
  ]
end