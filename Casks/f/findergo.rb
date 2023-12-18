cask "findergo" do
  version "1.4.0"
  sha256 "0484e158c4fd95c5ecb8bbdb14a01a039268758fb5bb1cc1754d78e2592db638"

  url "https:github.comonmyway133FinderGoreleasesdownload#{version}FinderGo.zip"
  name "FinderGo"
  desc "Open terminal quickly from Finder"
  homepage "https:github.comonmyway133FinderGo"

  depends_on macos: ">= :sierra"

  app "FinderGo.app"
end