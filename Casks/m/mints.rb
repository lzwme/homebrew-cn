cask "mints" do
  version "1.20,2024.11"
  sha256 "244671bda59a5ae3d8f232e6dfb093c81aa70caa3efd20b2928124a3015835d1"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}mints#{version.csv.first.no_dots}.zip"
  name "Mints"
  desc "Logging tool suite"
  homepage "https:eclecticlight.comints-a-multifunction-utility"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Mints']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "mints#{version.csv.first.no_dots}Mints.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.mints.sfl*",
    "~LibraryCachesco.eclecticlight.Mints",
    "~LibraryHTTPStoragesco.eclecticlight.Mints",
    "~LibraryPreferencesco.eclecticlight.Mints.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Mints.savedState",
  ]
end