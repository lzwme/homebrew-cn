cask "xattred" do
  version "1.5,2023.05"
  sha256 "044fdd02921e867a4dd78b3979c55d8efacbd526ea4fcc5bc560523d58bc66b6"

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}xattred#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "xattred"
  desc "Extended attribute editor"
  homepage "https:eclecticlight.coxattred-sandstrip-xattr-tools"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='xattred']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "xattred#{version.csv.first.major}#{version.csv.first.minor}xattred.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.xattred.sfl*",
    "~LibraryCachesco.eclecticlight.xattred",
    "~LibraryHTTPStoragesco.eclecticlight.xattred",
    "~LibraryPreferencesco.eclecticlight.xattred.plist",
    "~LibrarySaved Application Stateco.eclecticlight.xattred.savedState",
  ]
end