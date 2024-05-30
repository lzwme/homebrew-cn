cask "favtool" do
  version "4.3"
  sha256 "1ae7d059528041d225aea904aac736b8069991d860a6d0f58c30adfce086bfac"

  url "https:github.comshy-neonfavtoolreleasesdownloadv#{version}Favtool.app.zip"
  name "Favtool"
  desc "Easily change icons of your favorite sites on Safari"
  homepage "https:github.comshy-neonfavtool"

  livecheck do
    url :stable
  end

  app "Favtool.app"

  zap trash: [
    "~LibraryPreferencesshy-neon.Favtool.plist",
    "~LibrarySaved Application Stateshy-neon.Favtool.savedState",
  ]
end