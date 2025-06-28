cask "cirrus" do
  version "1.16,2025.06"
  sha256 "bcdeeaaf734fa9359336f65033d81a51bf405a91b431fe7f33d7626d1ad46ccf"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}cirrus#{version.csv.first.no_dots}.zip"
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

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "cirrus#{version.csv.first.major}#{version.csv.first.minor}Cirrus.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.cirrusmac.sfl*",
    "~LibraryCachesco.eclecticlight.CirrusMac",
    "~LibraryHTTPStoragesco.eclecticlight.CirrusMac",
    "~LibraryPreferencesco.eclecticlight.CirrusMac.plist",
    "~LibrarySaved Application Stateco.eclecticlight.CirrusMac.savedState",
  ]
end