cask "versatility" do
  version "1.0,2024.03"
  sha256 "fa92b1681fea7119f33ae5d67f6315a9675eba1e8e1e702ae669c70e4e13c167"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}#{token}#{version.csv.first.no_dots}.zip"
  name "Versatility"
  desc "Archive and unarchive saved versions to protect and preserve them"
  homepage "https:eclecticlight.corevisionist-deeptools"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Versatility']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "versatility#{version.csv.first.no_dots}Versatility.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.versatility.sfl*",
    "~LibraryCachesco.eclecticlight.Versatility",
    "~LibraryHTTPStoragesco.eclecticlight.Versatility",
    "~LibraryPreferencesco.eclecticlight.Versatility.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Versatility.savedState",
  ]
end