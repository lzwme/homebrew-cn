cask "silentknight" do
  on_mojave :or_older do
    version "1.21,2022.06"
    sha256 "c1cbb734f620e073f1c08c473edaa036c2b5ccdca02baa99ca117f86c10ad505"

    livecheck do
      skip "Legacy version"
    end

    depends_on macos: ">= :el_capitan"
  end
  on_catalina :or_newer do
    version "2.08,2024.05"
    sha256 "c1c7b462c5510bdaa62992b0441a20e46415b3f9a06ab8965f6eb227c406e438"

    livecheck do
      url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
      regex(%r{(\d+)(\d+)[^]+?$}i)
      strategy :xml do |xml, regex|
        item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='SilentKnight#{version.major}']]"]
        next unless item

        version = item.elements["key[text()='Version']"]&.next_element&.text&.strip
        match = item.elements["key[text()='URL']"]&.next_element&.text&.strip&.match(regex)
        next if version.blank? || match.blank?

        # Temporarily override the version to account for a one-off mismatch
        version = "2.08" if version == "2.8"

        "#{version},#{match[1]}.#{match[2]}"
      end
    end

    depends_on macos: ">= :catalina"
  end

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}silentknight#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "SilentKnight"
  desc "Automatically checks computer's security"
  homepage "https:eclecticlight.colockrattler-systhist"

  app "silentknight#{version.csv.first.no_dots}SilentKnight.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.eclecticlight.silentknight.sfl*",
    "~LibraryCachesco.eclecticlight.SilentKnight",
    "~LibraryHTTPStoragesco.eclecticlight.SilentKnight",
    "~LibraryPreferencesco.eclecticlight.SilentKnight.plist",
    "~LibrarySaved Application Stateco.eclecticlight.SilentKnight.savedState",
  ]
end