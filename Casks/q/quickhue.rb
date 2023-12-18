cask "quickhue" do
  version "1.3.3"
  sha256 :no_check

  url "https:github.comdanparsonsQuickHuerawmasterQuickHue.zip"
  name "QuickHue"
  desc "Menu bar utility for controlling the Philips Hue lighting system"
  homepage "https:github.comdanparsonsQuickHue"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "QuickHue.app"

  zap trash: [
    "~LibraryApplication SupportQuickHue",
    "~LibraryCachescat.moo.QuickHue",
    "~LibraryPreferencescat.moo.QuickHue.plist",
  ]
end