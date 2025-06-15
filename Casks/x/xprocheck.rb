cask "xprocheck" do
  version "1.6,2024.07"
  sha256 "6775fd9beb44d018a0287a00b944dc39a402763985cdaa19598b7d11167dabaa"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}xprocheck#{version.csv.first.no_dots}-1.zip"
  name "XProCheck"
  desc "Anti-malware scan logging tool"
  homepage "https:eclecticlight.coconsolation-t2m2-and-log-utilities"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='XProCheck']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "xprocheck#{version.csv.first.no_dots}XProCheck.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.XProCheck",
    "~LibraryHTTPStoragesco.eclecticlight.XProCheck",
    "~LibraryPreferencesco.eclecticlight.XProCheck.plist",
    "~LibrarySaved Application Stateco.eclecticlight.XProCheck.savedState",
  ]
end