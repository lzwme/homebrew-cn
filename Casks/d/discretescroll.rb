cask "discretescroll" do
  version "1.2.0"
  sha256 "660bbff46cf637921b3d255a6adf8c37f75aada7902c5da6f4842183c89c0bde"

  url "https:github.comemreyolcudiscrete-scrollreleasesdownloadv#{version}DiscreteScroll.zip"
  name "DiscreteScroll"
  desc "Utility to fix a common scroll wheel problem"
  homepage "https:github.comemreyolcudiscrete-scroll"

  app "DiscreteScroll.app"

  zap trash: "~LibraryPreferencescom.emreyolcu.DiscreteScroll.plist"
end