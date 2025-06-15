cask "sparkleshare" do
  version "3.28"
  sha256 "d0e561706b65d379ae947f77a2fc443395b69462d1dd968ac334155c73a38381"

  url "https:github.comhbonsSparkleSharereleasesdownload#{version}sparkleshare-mac-#{version}.zip",
      verified: "github.comhbonsSparkleShare"
  name "SparkleShare"
  desc "Tool to sync with any Git repository instantly"
  homepage "https:sparkleshare.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-14", because: :discontinued

  app "SparkleShare.app"

  caveats do
    requires_rosetta
  end
end