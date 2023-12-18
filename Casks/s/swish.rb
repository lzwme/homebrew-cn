cask "swish" do
  version "1.10.3"
  sha256 "b41b769d7ca7cdc8abf36fb6a27dd00ca9548af11634ab24c73cafa653f44608"

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