cask "metamer" do
  version "1.5,2023.11"
  sha256 "bd158fd3afe0837a5a312858be50ec285f417945c04131d8570fe55cf22112f6"

  url "https://eclecticlight.co/wp-content/uploads/#{version.csv.second.major}/#{version.csv.second.minor}/metamer#{version.csv.first.no_dots}.zip"
  name "Metamer"
  desc "Accessible metadata editor for 16 Spotlight extended attributes"
  homepage "https://eclecticlight.co/xattred-sandstrip-xattr-tools/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/hoakleyelc/updates/master/eclecticapps.plist"
    regex(%r{/(\d+)/(\d+)/[^/]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["//dict[key[text()='AppName']/following-sibling::*[1][text()='Metamer']]"]
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

  app "metamer#{version.csv.first.no_dots}/Metamer.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/co.eclecticlight.metamer.sfl*",
    "~/Library/Caches/co.eclecticlight.Metamer",
    "~/Library/HTTPStorages/co.eclecticlight.Metamer",
    "~/Library/Preferences/co.eclecticlight.Metamer.plist",
    "~/Library/Saved Application State/co.eclecticlight.Metamer.savedState",
  ]
end