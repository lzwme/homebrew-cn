cask "cirrus" do
  version "1.15,2024.09"
  sha256 "0c62650f938de2fd626f692d0746291ac3876b1a4485546991fb4351efb0c860"

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

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
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