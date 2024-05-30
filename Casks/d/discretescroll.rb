cask "discretescroll" do
  version "1.0.1"
  sha256 "e93595d2ad8f2cd7eaace41582d4734e4de19f547cf9d524724a5f30cb4a4b61"

  url "https:github.comemreyolcudiscrete-scrollreleasesdownloadv#{version}DiscreteScroll.zip"
  name "DiscreteScroll"
  desc "Utility to fix a common scroll wheel problem"
  homepage "https:github.comemreyolcudiscrete-scroll"

  app "DiscreteScroll.app"

  zap trash: "~LibraryPreferencescom.emreyolcu.DiscreteScroll.plist"
end