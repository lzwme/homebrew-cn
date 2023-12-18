cask "multi" do
  version "3.0.0"
  sha256 "f3f118ea3616638166095d28502a84fde3449d897d064e6c0a801f65c0f3f536"

  url "https:github.comhkgumbsmultireleasesdownloadv#{version}Multi.#{version}.dmg"
  name "Multi"
  desc "Create apps from groups of websites"
  homepage "https:github.comhkgumbsmulti"

  app "Multi.app"

  zap trash: [
    "~LibraryCachesllc.gumbs.multi.*",
    "~LibraryCachesllc.gumbs.multi",
    "~LibraryPreferencesllc.gumbs.multi.*.plist",
    "~LibrarySaved Application Statellc.gumbs.multi.savedState",
  ]
end