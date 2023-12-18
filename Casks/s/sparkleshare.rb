cask "sparkleshare" do
  version "3.28"
  sha256 "d0e561706b65d379ae947f77a2fc443395b69462d1dd968ac334155c73a38381"

  url "https:github.comhbonsSparkleSharereleasesdownload#{version}sparkleshare-mac-#{version}.zip",
      verified: "github.comhbonsSparkleShare"
  name "SparkleShare"
  desc "Tool to sync with any Git repository instantly"
  homepage "https:sparkleshare.org"

  livecheck do
    url "https:github.comhbonsSparkleSharereleases"
    regex(sparkleshare[._-]?mac[._-]?(\d+(?:\.\d+)*)\.zipi)
    strategy :page_match
  end

  app "SparkleShare.app"
end