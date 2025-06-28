cask "revisionist" do
  version "1.10,2025.06"
  sha256 "e01335c4fb1fa61b03f8d4714e758d206aa439ff260ae2cd1c0c84e307b63c0f"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}#{token}#{version.csv.first.no_dots}.zip"
  name "Revisionist"
  desc "Opens up the full power of the versioning system"
  homepage "https:eclecticlight.corevisionist-deeptools"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Revisionist']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "revisionist#{version.csv.first.no_dots}Revisionist.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.revisionist.sfl*",
    "~LibraryCachesco.eclecticlight.Revisionist",
    "~LibraryCachescom.apple.helpdGeneratedco.eclecticlight.Revisionist.help*",
    "~LibraryHTTPStoragesco.eclecticlight.Revisionist",
    "~LibraryPreferencesco.eclecticlight.Revisionist.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Revisionist.savedState",
  ]
end