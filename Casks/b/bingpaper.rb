cask "bingpaper" do
  version "0.11.1,46"
  sha256 "29694e8ae3bea1a50719865ffe4ca19e7794b1c7dc733a2cd532056cf35641ee"

  url "https:github.compengsrcBingPaperreleasesdownloadv#{version.csv.first}BingPaper.v#{version.csv.first}.build.#{version.csv.second}.zip"
  name "BingPaper"
  desc "Use the Bing daily photo as your wallpaper"
  homepage "https:github.compengsrcBingPaper"

  depends_on macos: ">= :catalina"

  app "BingPaper.app"

  uninstall launchctl: "io.pjw.mac.BingPaperLoginItem",
            quit:      "io.pjw.mac.BingPaper"

  zap rmdir: "~PicturesBingPaper",
      trash: [
        "~LibraryApplication Scriptsio.pjw.mac.BingPaper",
        "~LibraryApplication Scriptsio.pjw.mac.BingPaperLoginItem",
        "~LibraryContainersio.pjw.mac.BingPaper",
        "~LibraryContainersio.pjw.mac.BingPaperLoginItem",
      ]

  caveats do
    discontinued
  end
end