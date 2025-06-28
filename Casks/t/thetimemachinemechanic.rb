cask "thetimemachinemechanic" do
  version "2.03,2025.06"
  sha256 "d1eafe2bb10465822d24b15ed42a5c618364cb2a36816326a63b0babceaa6247"

  url "https:eclecticlight.cowp-contentuploads#{version.csv.second.major}#{version.csv.second.minor}t2m2#{version.csv.first.no_dots}.zip"
  name "The Time Machine Mechanic"
  name "T2M2"
  desc "Time Machine log viewer & status inspector"
  homepage "https:eclecticlight.coconsolation-t2m2-and-log-utilities"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :xml do |xml, regex|
      item = xml.elements["dict[key[text()='AppName']following-sibling::*[1][text()='T2M22']]"]
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      url = item.elements["key[text()='URL']"]&.next_element&.text
      match = url.strip.match(regex) if url
      next if version.blank? || match.blank?

      "#{version.strip},#{match[1]}.#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "t2m2#{version.csv.first.major}#{version.csv.first.minor}TheTimeMachineMechanic.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.TheTimeMachineMechanic2",
    "~LibraryHTTPStoragesco.eclecticlight.TheTimeMachineMechanic2",
    "~LibraryPreferencesco.eclecticlight.TheTimeMachineMechanic2.plist",
    "~LibrarySaved Application Stateco.eclecticlight.TheTimeMachineMechanic2.savedState",
  ]
end