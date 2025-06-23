cask "honer" do
  version "1.1"
  sha256 "ca6b657bec7fd20e2cae8c7145852439148211b9d4aac9ab12c354c69426c043"

  url "https:github.compuffnfreshHoner.appreleasesdownload#{version}Honer.app.zip"
  name "Honer"
  desc "Utility that draws a border around the focused window"
  homepage "https:github.compuffnfreshHoner.app"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-22", because: :discontinued
  disable! date: "2025-06-22", because: :discontinued

  app "Honer.app"

  caveats do
    requires_rosetta
  end
end