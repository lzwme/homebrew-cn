cask "swish" do
  version "1.12"
  sha256 "52c99ab359f651ab01026db5c2cfb08e460da7bf06b6fe0b94d78f245553587e"

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