cask "thetimemachinemechanic" do
  version "2.00,2024.01"
  sha256 "b2237496f9ec5d703a7f7abb469d1ed486f151d46792bdaad7c4d9d970b1556f"

  url "https:eclecticlightdotcom.files.wordpress.com#{version.csv.second.major}#{version.csv.second.minor}t2m2#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com"
  name "The Time Machine Mechanic"
  name "T2M2"
  desc "Time Machine log viewer & status inspector"
  homepage "https:eclecticlight.coconsolation-t2m2-and-log-utilities"

  livecheck do
    url "https:raw.githubusercontent.comhoakleyelcupdatesmastereclecticapps.plist"
    regex(%r{(\d+)(\d+)t2m2(\d+)\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[2].split("", 2).join(".")},#{match[0]}.#{match[1]}"
      end
    end
  end

  depends_on macos: ">= :sierra"

  app "t2m2#{version.csv.first.major}#{version.csv.first.minor}TheTimeMachineMechanic.app"

  zap trash: [
    "~LibraryCachesco.eclecticlight.TheTimeMachineMechanic",
    "~LibraryPreferencesco.eclecticlight.TheTimeMachineMechanic.plist",
    "~LibrarySaved Application Stateco.eclecticlight.TheTimeMachineMechanic.savedState",
  ]
end