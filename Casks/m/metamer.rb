cask "metamer" do
  version "1.5,2023.11"
  sha256 "bd158fd3afe0837a5a312858be50ec285f417945c04131d8570fe55cf22112f6"

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}metamer#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "Metamer"
  desc "Accessible metadata editor for 16 Spotlight extended attributes"
  homepage "https:eclecticlight.coxattred-sandstrip-xattr-tools"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    strategy :page_match do |page|
      match = page.match(%r{(\d+)(\d+)metamer(\d+)\.zip}i)
      next if match.blank?

      "#{match[3].split("", 2).join(".")},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :mojave"

  app "metamer#{version.csv.first.no_dots}Metamer.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.Metamer",
    "~LibraryHTTPStoragesco.eclecticlight.Metamer",
    "~LibraryPreferencesco.eclecticlight.Metamer.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Metamer.savedState",
  ]
end