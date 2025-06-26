cask "precize" do
  version "1.16,2025.06"
  sha256 "e798832aa867e017a7be4d0dd53ed9c9785155820264c851e2ee552ab767e049"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}precize#{version.csv.first.no_dots}.zip"
  name "Precize"
  desc "Detailed information for files, bundles and folders"
  homepage "https:eclecticlight.cotaccy-signet-precize-alifix-utiutility-alisma"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Precize']]"]
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

  app "precize#{version.csv.first.no_dots}Precize.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.Precize",
    "~LibraryHTTPStoragesco.eclecticlight.Precize",
    "~LibraryPreferencesco.eclecticlight.Precize.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Precize.savedState",
  ]
end