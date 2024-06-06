cask "discretescroll" do
  version "1.2.1"
  sha256 "f2cc275e4537811bf35b2cec2128c086eefbe613c3b79b08819f4f966f1f7a60"

  url "https:github.comemreyolcudiscrete-scrollreleasesdownloadv#{version}DiscreteScroll.zip"
  name "DiscreteScroll"
  desc "Utility to fix a common scroll wheel problem"
  homepage "https:github.comemreyolcudiscrete-scroll"

  app "DiscreteScroll.app"

  zap trash: "~LibraryPreferencescom.emreyolcu.DiscreteScroll.plist"
end