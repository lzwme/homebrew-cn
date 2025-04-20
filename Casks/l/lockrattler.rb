cask "lockrattler" do
  version "4.37,2023.05"
  sha256 "e0313e7116136d98201c01b09eefe3a221889579debe68457e88488bfa60b78e"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}lockrattler#{version.csv.first.no_dots}.zip"
  name "Lock Rattler"
  desc "Checks security systems and reports issues"
  homepage "https:eclecticlight.colockrattler-systhist"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='LockRattler']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  depends_on macos: ">= :high_sierra"

  app "lockrattler#{version.csv.first.major}#{version.csv.first.minor}LockRattler.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.LockRattler",
    "~LibraryHTTPStoragesco.eclecticlight.LockRattler",
    "~LibraryPreferencesco.eclecticlight.LockRattler.plist",
    "~LibrarySaved Application Stateco.eclecticlight.LockRattler.savedState",
  ]
end