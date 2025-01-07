cask "hackintool" do
  version "4.0.3"
  sha256 :no_check # required as upstream package is updated in-place

  url "https:github.comheadkazeHackintoolreleasesdownload#{version}Hackintool.zip"
  name "Hackintool"
  desc "Hackintosh patching tool"
  homepage "https:github.comheadkazeHackintool"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Hackintool.app"

  zap trash: [
    "~LibraryCachescom.apple.helpdGeneratedcom.Headsoft.Hackintool.help*",
    "~LibraryCachescom.Headsoft.Hackintool",
    "~LibraryCookiescom.Headsoft.Hackintool.binarycookies",
    "~LibraryPreferencescom.Headsoft.Hackintool.plist",
  ]

  caveats do
    requires_rosetta
  end
end