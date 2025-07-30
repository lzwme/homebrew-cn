cask "dynalist" do
  version "1.0.6"
  sha256 :no_check

  url "https://dynalist.io/standalone/download?file=Dynalist.dmg"
  name "Dynalist"
  desc "Outlining app for your work"
  homepage "https://dynalist.io/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-29", because: :unmaintained
  disable! date: "2025-07-29", because: :unmaintained

  app "Dynalist.app"

  caveats do
    requires_rosetta
  end
end