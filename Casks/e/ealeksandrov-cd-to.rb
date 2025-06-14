cask "ealeksandrov-cd-to" do
  version "2.8.0"
  sha256 "bcc450c23da12a2e3b82ad60ca3698b0464ee96b11cc077348d26ad1b2439600"

  url "https:github.comealeksandrovcdtoreleasesdownload#{version.dots_to_underscores}cd_to_#{version.major_minor.dots_to_underscores}.zip"
  name "cd_to"
  desc "Finder Toolbar app to open the current directory in the Terminal"
  homepage "https:github.comealeksandrovcdto"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-14", because: :unmaintained

  app "cd_to_#{version.major_minor.dots_to_underscores}terminalcd_to.app"

  caveats do
    requires_rosetta
  end
end