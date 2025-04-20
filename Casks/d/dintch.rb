cask "dintch" do
  version "1.6,2023.05"
  sha256 "61444cc980f6c6f9dc11bf222e60d04d479b96d3c3d5f8cbbae3675809a9292a"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}dintch#{version.csv.first.no_dots}.zip"
  name "Dintch"
  desc "Check the integrity of your files"
  homepage "https:eclecticlight.codintch"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Dintch']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "dintch#{version.csv.first.no_dots}Dintch.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.dintch.sfl*",
    "~LibraryCachesco.eclecticlight.Dintch",
    "~LibraryHTTPStoragesco.eclecticlight.Dintch",
    "~LibraryPreferencesco.eclecticlight.Dintch.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Dintch.savedState",
  ]
end