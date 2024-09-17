cask "swish" do
  version "1.10.4"
  sha256 "1ca142fdc5b771d04ed30e8e54cf7667665cfc1487a028541fb6d4e37e72df8d"

  url "https:github.comchrennswish-dlreleasesdownload#{version}Swish.dmg",
      verified: "github.comchrennswish-dl"
  name "Swish"
  desc "Control windows and applications right from your trackpad"
  homepage "https:highlyopinionated.coswish"

  livecheck do
    url "https:highlyopinionated.coswishappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Swish.app"

  zap trash: [
    "~LibraryApplication SupportSwish",
    "~LibraryCachesco.highlyopinionated.swish",
    "~LibraryCookiesco.highlyopinionated.swish.binarycookies",
    "~LibraryPreferencesco.highlyopinionated.swish.plist",
  ]
end