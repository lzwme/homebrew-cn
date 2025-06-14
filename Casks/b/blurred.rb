cask "blurred" do
  version "1.2.0"
  sha256 "15903ce2484f783c53cbad905ea93a5045c87767e7b89e37300d2200902dff37"

  url "https:github.comdwarvesfblurredreleasesdownloadv#{version}Blurred.#{version}.dmg"
  name "Blurred"
  desc "Utility to dim backgroundinactive content in the screen"
  homepage "https:github.comdwarvesfblurred"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Blurred.app"

  uninstall launchctl: "foundation.dwarves.blurredlaunche",
            quit:      "foundation.dwarves.blurred"

  zap trash: [
    "~LibraryApplication Scriptsfoundation.dwarves.blurred",
    "~LibraryApplication Scriptsfoundation.dwarves.blurredlauncher",
    "~LibraryContainersfoundation.dwarves.blurred",
    "~LibraryContainersfoundation.dwarves.blurredlauncher",
  ]

  caveats do
    requires_rosetta
  end
end