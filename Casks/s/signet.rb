cask "signet" do
  version "1.3,2020.09"
  sha256 "ea48e77577e46848d5a3861782ddaaf05a725e6a4f14802ee29bc20bd88aeb50"

  url "https://eclecticlight.co/wp-content/uploads/#{version.csv.second.major}/#{version.csv.second.minor}/#{token}#{version.csv.first.no_dots}.zip"
  name "Signet"
  desc "Scans and checks bundle signatures"
  homepage "https://eclecticlight.co/taccy-signet-precize-alifix-utiutility-alisma/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/hoakleyelc/updates/master/eclecticapps.plist"
    regex(%r{/(\d+)/(\d+)/[^/]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["//dict[key[text()='AppName']/following-sibling::*[1][text()='Signet']]"]
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

  app "#{token}#{version.csv.first.no_dots}/Signet.app"

  zap trash: [
    "~/Library/Caches/co.eclecticlight.Signet",
    "~/Library/HTTPStorages/co.eclecticlight.Signet",
    "~/Library/Preferences/co.eclecticlight.Signet.plist",
    "~/Library/Saved Application State/co.eclecticlight.Signet.savedState",
  ]
end