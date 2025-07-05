cask "versatility" do
  version "1.1,2025.06"
  sha256 "b18a71ad83a9ff24e8accdc8b96dbf180fd3e658e8868a9c4ec46468d599f130"

  url "https://eclecticlight.co/wp-content/uploads/#{version.csv.second.major}/#{version.csv.second.minor}/#{token}#{version.csv.first.no_dots}.zip"
  name "Versatility"
  desc "Archive and unarchive saved versions to protect and preserve them"
  homepage "https://eclecticlight.co/revisionist-deeptools/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/hoakleyelc/updates/master/eclecticapps.plist"
    regex(%r{/(\d+)/(\d+)/[^/]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["//dict[key[text()='AppName']/following-sibling::*[1][text()='Versatility']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "versatility#{version.csv.first.no_dots}/Versatility.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/co.eclecticlight.versatility.sfl*",
    "~/Library/Caches/co.eclecticlight.Versatility",
    "~/Library/HTTPStorages/co.eclecticlight.Versatility",
    "~/Library/Preferences/co.eclecticlight.Versatility.plist",
    "~/Library/Saved Application State/co.eclecticlight.Versatility.savedState",
  ]
end