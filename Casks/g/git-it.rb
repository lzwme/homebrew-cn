cask "git-it" do
  version "4.4.0"
  sha256 "b96c06bca744af94e2f035824fbd16f59673c4c454fd4bf96aa4bde965fe711d"

  url "https:github.comjlordgit-it-electronreleasesdownload#{version}Git-it-Mac-x64.zip"
  name "Git-it"
  desc "Desktop app for learning Git and GitHub"
  homepage "https:github.comjlordgit-it-electron"

  no_autobump! because: :requires_manual_review

  app "Git-it-Mac-x64Git-it.app"

  zap trash: [
    "~LibraryApplication SupportGit-it",
    "~LibraryPreferencescom.electron.git-it.helper.plist",
    "~LibraryPreferencescom.electron.git-it.plist",
  ]

  caveats do
    requires_rosetta
  end
end