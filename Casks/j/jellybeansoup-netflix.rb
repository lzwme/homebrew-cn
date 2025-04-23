cask "jellybeansoup-netflix" do
  version "1.0.5"
  sha256 "6e62f4e8a5883f139a7259464e33039e7cd5c6040caf9dbb27d85f890b576c40"

  url "https:jellystyle-d5a.kxcdn.commacosnetflixNetflix.v#{version}.zip",
      verified: "jellystyle-d5a.kxcdn.com"
  name "Netflix"
  desc "Third-party app to use Netflix outside the browser"
  homepage "https:github.comjellybeansoupmacos-netflix"

  livecheck do
    url "https:jellystyle.comresourcesmacOSNetflix.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true

  app "Netflix.app"

  zap trash: [
    "~LibraryCachescom.jellystyle.Netflix-wrapper",
    "~LibraryPreferencescom.jellystyle.Netflix-wrapper.plist",
    "~LibrarySaved Application Statecom.jellystyle.Netflix-wrapper.savedState",
  ]
end