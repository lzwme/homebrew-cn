cask "gitahead" do
  version "2.7.1"
  sha256 "32c17d345fedc869efd37080d0905aa1a85d8d5ba5a4509058fdd35f224f2a04"

  url "https:github.comgitaheadgitaheadreleasesdownloadv#{version}GitAhead-#{version}.dmg"
  name "GitAhead"
  desc "Git Client"
  homepage "https:github.comgitaheadgitahead"

  depends_on macos: ">= :big_sur"

  app "GitAhead.app"

  zap trash: [
    "~LibraryApplication SupportGitAhead",
    "~LibraryPreferencescom.gitahead.GitAhead.plist",
    "~LibrarySaved Application Statecom.gitahead.GitAhead.savedState",
  ]
end