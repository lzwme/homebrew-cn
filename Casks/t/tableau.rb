cask "tableau" do
  version "2023.3.3"
  sha256 "e3112fa86137326df1fb24e889347e72db04111d5d9297d6fafb84f38720ecad"

  url "https://downloads.tableau.com/tssoftware/TableauDesktop-#{version.dots_to_hyphens}.dmg"
  name "Tableau Desktop"
  desc "Data visualization software"
  homepage "https://www.tableau.com/products/desktop"

  livecheck do
    url "https://www.tableau.com/downloads/desktop/mac"
    strategy :header_match do |headers|
      headers["location"][/TableauDesktop[._-]v?(\d+(?:-\d+)+)\.dmg/i, 1].tr("-", ".")
    end
  end

  depends_on macos: ">= :mojave"

  pkg "Tableau Desktop.pkg"

  uninstall pkgutil: [
    "com.amazon.redshiftodbc",
    "com.simba.sparkodbc",
    "com.simba.sqlserverodbc",
    "com.tableausoftware.Desktop.app",
    "com.tableausoftware.DesktopShortcut",
    "com.tableausoftware.extensions",
    "com.tableausoftware.FLEXNet.*",
    "com.tableausoftware.mysql",
    "com.tableausoftware.networkExtensions",
    "com.tableausoftware.oracle",
    "com.tableausoftware.postgresql",
    "com.tableausoftware.telemetry",
    "simba.sparkodbc",
  ]

  zap delete: "/Library/Preferences/com.tableau.Tableau-#{version.major_minor}.plist",
      trash:  [
        "/Library/Preferences/com.tableau.Tableau-#{version.major_minor}.plist",
        "~/Documents/My Tableau Repository",
        "~/Library/Caches/com.tableau.caching",
        "~/Library/Caches/com.tableausoftware.MapTiles",
        "~/Library/Preferences/com.tableau.Registration.plist",
        "~/Library/Preferences/com.tableau.Tableau-#{version.major_minor}.plist",
        "~/Library/Saved Application State/com.tableausoftware.tableaudesktop.savedState",
        "~/Library/Tableau",
      ]
end