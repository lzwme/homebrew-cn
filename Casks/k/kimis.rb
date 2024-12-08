cask "kimis" do
  version "1.17"
  sha256 "cfe11de54a57bee62c639d108c015bdc290c18b77ad6ab8043b1cce6010d0fae"

  url "https:github.comLakr233Kimisreleasesdownload#{version}Kimis.zip"
  name "Kimis"
  desc "Desktop client for Misskey"
  homepage "https:github.comLakr233Kimis"

  depends_on macos: ">= :big_sur"

  app "Kimis.app"

  uninstall quit: "as.wiki.qaq.kimi"

  zap trash: [
    "~LibraryApplication Scriptsas.wiki.qaq.kimis",
    "~LibraryContainersas.wiki.qaq.kimis",
  ]
end