cask "quickhue" do
  version "1.3.3"
  sha256 :no_check

  url "https:github.comdanparsonsQuickHuerawmasterQuickHue.zip"
  name "QuickHue"
  desc "Menu bar utility for controlling the Philips Hue lighting system"
  homepage "https:github.comdanparsonsQuickHue"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-04", because: :discontinued

  app "QuickHue.app"

  zap trash: [
    "~LibraryApplication SupportQuickHue",
    "~LibraryCachescat.moo.QuickHue",
    "~LibraryPreferencescat.moo.QuickHue.plist",
  ]

  caveats do
    requires_rosetta
  end
end