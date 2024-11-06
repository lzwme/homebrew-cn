cask "spundle" do
  version "1.8,2023.12"
  sha256 "4c6692bc9cf1f6bdd006ee64a539bf5c2f0ebaddfd7bf27548d912bef120d513"

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}spundle#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "spundle"
  desc "Create, resize and compact sparse bundles"
  homepage "https:eclecticlight.codintch"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='Spundle']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "spundle#{version.csv.first.no_dots}Spundle.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.spundle.sfl*",
    "~LibraryCachesco.eclecticlight.Spundle",
    "~LibraryHTTPStoragesco.eclecticlight.Spundle",
    "~LibraryPreferencesco.eclecticlight.Spundle.plist",
    "~LibrarySaved Application Stateco.eclecticlight.Spundle.savedState",
  ]
end