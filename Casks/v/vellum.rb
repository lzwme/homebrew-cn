cask "vellum" do
  version "3.9,39009"
  sha256 "04b8090975b66a937a92978ce153532acd33fa92f920c077eb989964f91351a6"

  url "https://180g.s3.amazonaws.com/downloads/Vellum-#{version.csv.second}.zip",
      verified: "180g.s3.amazonaws.com/downloads/"
  name "Vellum"
  desc "Ebook creation software"
  homepage "https://vellum.pub/"

  livecheck do
    url "https://get.180g.co/updates/vellum/"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Vellum.app"

  zap trash: [
    "~/Library/Application Scripts/co.180g.Vellum",
    "~/Library/Containers/co.180g.Vellum",
  ]
end