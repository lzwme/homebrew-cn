cask "unipro-ugene" do
  version "49.1"
  sha256 "ab78910618f1ca00c185d8b5cb3ff43f3a27fd11a59c5c3337aa360147795fb7"

  url "https:github.comugeneuniprougenereleasesdownload#{version}ugene-#{version}-mac-x86-64.dmg",
      verified: "github.comugeneuniprougene"
  name "Ugene"
  desc "Free open-source cross-platform bioinformatics software"
  homepage "https:ugene.net"

  app "Unipro UGENE.app"

  zap trash: [
    "~LibraryPreferencescom.unipro.UGENE.plist",
    "~LibraryPreferencesnet.ugene.ugene.plist",
  ]
end