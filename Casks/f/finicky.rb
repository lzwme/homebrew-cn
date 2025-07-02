cask "finicky" do
  version "4.1.4"
  sha256 "2b20d949faf47db259a2b4a94b4986e2010e479ec2aba096c2ad6faa259a5e8d"

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