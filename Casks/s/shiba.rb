cask "shiba" do
  version "1.2.1"
  sha256 "599dc0db44d82145fb71583cdca6561077d72e532bf132a4b013a360f7b9ba82"

  url "https:github.comrhysdShibareleasesdownloadv#{version}Shiba-darwin-x64.zip"
  name "Shiba"
  desc "Rich markdown live preview app with linter"
  homepage "https:github.comrhysdShiba"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-16", because: :unmaintained

  app "Shiba-darwin-x64Shiba.app"

  caveats do
    requires_rosetta
  end
end