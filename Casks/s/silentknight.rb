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
    version "2.07,2023.11"
    sha256 "90bc1b10f02f09c2a684a0f04242f2e93b1aadd912e5341bc5a7415cfe8f0c62"

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
        version = "2.07" if version == "2.7"

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