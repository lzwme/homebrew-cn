cask "discretescroll" do
  version "1.1.0"
  sha256 "745d376c3f2158880f58ecea99bede1b2e3d20ee363b7117a3ca632aed52b55b"

  url "https:github.comemreyolcudiscrete-scrollreleasesdownloadv#{version}DiscreteScroll.zip"
  name "DiscreteScroll"
  desc "Utility to fix a common scroll wheel problem"
  homepage "https:github.comemreyolcudiscrete-scroll"

  app "DiscreteScroll.app"

  zap trash: "~LibraryPreferencescom.emreyolcu.DiscreteScroll.plist"
end