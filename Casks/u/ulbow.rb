cask "ulbow" do
  version "1.11,2025.06"
  sha256 "7665a3124538c08c52855a9863d1865507007095dfaac0d9ce8f89e4e53e30f8"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}ulbow#{version.csv.first.no_dots}.zip"
  name "Ulbow"
  desc "Log browser"
  homepage "https:eclecticlight.coconsolation-t2m2-and-log-utilities"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Ulbow']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "ulbow#{version.csv.first.no_dots}Ulbow.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.ulbow.sfl*",
    "~LibraryCachesco.eclecticlight.Ulbow",
    "~LibraryHTTPStoragesco.eclecticlight.Ulbow",
    "~LibraryPreferencesco.eclecticlight.Ulbow.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Ulbow.savedState",
  ]
end