cask "metamer" do
  version "1.5,2023.11"
  sha256 "bd158fd3afe0837a5a312858be50ec285f417945c04131d8570fe55cf22112f6"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}metamer#{version.csv.first.no_dots}.zip"
  name "Metamer"
  desc "Accessible metadata editor for 16 Spotlight extended attributes"
  homepage "https:eclecticlight.coxattred-sandstrip-xattr-tools"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Metamer']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "metamer#{version.csv.first.no_dots}Metamer.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.metamer.sfl*",
    "~LibraryCachesco.eclecticlight.Metamer",
    "~LibraryHTTPStoragesco.eclecticlight.Metamer",
    "~LibraryPreferencesco.eclecticlight.Metamer.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Metamer.savedState",
  ]
end