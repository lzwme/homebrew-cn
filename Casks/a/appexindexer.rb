cask "appexindexer" do
  version "108,2025.04"
  sha256 "9ee82b423ffdf998d75f945599bfb4e21abe6185591dc77e682f853cd975121f"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}appexindexer#{version.csv.first.no_dots}.zip"
  name "AppexIndexer"
  desc "List and inspect installed app extensions"
  homepage "https:eclecticlight.co20250410discover-appexes-with-appexindexer"

  livecheck do
    # Update to match other Eclectic Light casks if AppexIndexer is added to https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist
    url :homepage
    regex(%r{href=.*?wp-contentuploads(\d+)(\d+)appexindexer(\d+)\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[2]},#{match[0]}.#{match[1]}" }
    end
  end

  depends_on macos: ">= :sonoma"

  app "appexindexer#{version.csv.first.no_dots}AppexIndexer.app"

  zap trash: "~LibraryPreferencesco.eclecticlight.AppexIndexer.plist"
end