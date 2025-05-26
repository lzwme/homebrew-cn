cask "luanti" do
  arch arm: "arm64", intel: "x86_64_flag_O1"

  version "5.12.0,11.3"
  sha256 arm:   "59b04cfef02fcd2ce0529f3ff1a48256730a322ca16018af9059154b4dd72606",
         intel: "ce2d1174edaa4f2c3684cfacd6e686d90c299b775445dd11bad6daf9428f119b"

  url "https:github.comminetestminetestreleasesdownload#{version.csv.first}luanti_#{version.csv.first}-macos#{version.csv.second}_#{arch}.zip",
      verified: "github.comminetestminetest"
  name "Luanti"
  desc "Voxel game-creation platform"
  homepage "https:www.luanti.org"

  livecheck do
    url "https:www.luanti.orgdownloads"
    regex(href=.*?luanti[._-]v?(\d+(?:\.\d+)+)[._-]macos(\d+(?:\.\d+)+)[._-]#{arch}\.zipi)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  depends_on macos: ">= :big_sur"

  app "Luanti.app"

  zap trash: [
    "~LibraryApplication Supportminetest",
    "~LibrarySaved Application Stateorg.luanti.luanti.savedState",
  ]
end