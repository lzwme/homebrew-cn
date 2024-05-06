cask "cirrus" do
  version "1.14,2024.02"
  sha256 "9a0169344c6c37ed7907eb1d8f32c4e1f3b02907fd33b5e991bb8d2ebba906ee"

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}cirrus#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "Cirrus"
  desc "Inspector for iCloud Drive folders"
  homepage "https:eclecticlight.cocirrus-bailiff"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Cirrus']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text&.strip
      match = item.elements["key[text()='URL']"]&.next_element&.text&.strip&.match(regex)
      next if version.blank? || match.blank?

      "#{version},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "cirrus#{version.csv.first.major}#{version.csv.first.minor}Cirrus.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.cirrusmac.sfl*",
    "~LibraryCachesco.eclecticlight.CirrusMac",
    "~LibraryHTTPStoragesco.eclecticlight.CirrusMac",
    "~LibraryPreferencesco.eclecticlight.CirrusMac.plist",
    "~LibrarySaved Application Stateco.eclecticlight.CirrusMac.savedState",
  ]
end