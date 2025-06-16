cask "revisionist" do
  version "1.9,2023.06"
  sha256 "b63dbefe2587abe471ec08361d2f828040e2e654027982cfa3b42f632fc89b97"

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

  no_autobump! because: :requires_manual_review

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