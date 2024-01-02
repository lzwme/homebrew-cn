cask "aria2d" do
  version "1.3.9,433"
  sha256 "efa4be7b0c0d47c814e8d8f8d392d760dd5a02ba46829136f8a6404dffc2bf6f"

  url "https:github.comxjbetaAria2Dreleasesdownload#{version.csv.first}%28#{version.csv.second}%29Aria2D.#{version.csv.first}.dmg"
  name "Aria2D"
  desc "Aria2 GUI"
  homepage "https:github.comxjbetaAria2D"

  livecheck do
    url "https:raw.githubusercontent.comxjbetaAppUpdaterAppcastsmasterAria2DAppcast.xml"
    strategy :sparkle do |items|
      items.map(&:nice_version)
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Aria2D.app"

  zap trash: [
    "~LibraryApplication SupportAria2D",
    "~LibraryApplication Supportcom.xjbeta.Aria2D",
    "~LibraryPreferencescom.xjbeta.Aria2D.plist",
    "~LibrarySaved Application Statecom.xjbeta.Aria2D.savedState",
  ]
end