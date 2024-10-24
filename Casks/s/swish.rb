cask "swish" do
  version "1.11"
  sha256 "119c3104ac020a40765ffa79a8c98d13a2dca4ca5d8c63b46ddcae2c31a40ebe"

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