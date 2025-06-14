cask "dintch" do
  version "1.7,2025.04"
  sha256 "728960d47779e23f5ba3ffdda7184c074e06837a320aa38b536d32071c35e3b3"

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

  no_autobump! because: :requires_manual_review

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