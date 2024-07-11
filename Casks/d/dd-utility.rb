cask "dd-utility" do
  version "1.11"
  sha256 "1c33a998b7c9b7a9fa59222d2e7cc0410f0cec85650e8647308c33ee0af1e956"

  url "https:github.comthefanclubdd-utilityrawmasterDMGddUtility-#{version}.dmg"
  name "dd Utility"
  desc "Write and backup operating system IMG and ISO files"
  homepage "https:github.comthefanclubdd-utility"

  livecheck do
    url "https:github.comthefanclubdd-utilitytreemasterDMG"
    regex(ddUtility[._-]?v?(\d+(?:\.\d+)+)\.dmgi)
    strategy :page_match
  end

  app "dd Utility.app"

  zap trash: "~LibrarySaved Application Stateco.za.thefanclub.ddUtility.savedState"

  caveats do
    requires_rosetta
  end
end