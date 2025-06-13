cask "finicky" do
  version "4.1.3"
  sha256 "17501b900f45544a55ab8abab62a9e6757c931a59aa935a61ae18250d8d5d520"

  url "https:github.comjohnstefinickyreleasesdownloadv#{version}Finicky.dmg"
  name "Finicky"
  desc "Utility for customizing which browser to start"
  homepage "https:github.comjohnstefinicky"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Finicky.app"

  zap trash: "~LibraryPreferencesse.johnste.finicky.plist"
end