cask "multi" do
  version "3.0.1"
  sha256 "6df8a9f8db0b69733d91428eba815928bb3b65ec526a7c714de9d8e95a03e2f8"

  url "https:github.comhkgumbsmultireleasesdownloadv#{version}Multi.#{version}.dmg"
  name "Multi"
  desc "Create apps from groups of websites"
  homepage "https:github.comhkgumbsmulti"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"

  app "Multi.app"

  zap trash: [
    "~LibraryCachesllc.gumbs.multi",
    "~LibraryCachesllc.gumbs.multi.*",
    "~LibraryPreferencesllc.gumbs.multi.*.plist",
    "~LibrarySaved Application Statellc.gumbs.multi.savedState",
  ]
end