cask "kimis" do
  version "1.16"
  sha256 "ecb26278d31c2783472b012e874bcd7fde0adc02da8ef98106f18c12d4fb3e25"

  url "https:github.comLakr233Kimisreleasesdownload#{version}Kimis.#{version}.zip"
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