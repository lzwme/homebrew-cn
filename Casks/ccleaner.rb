cask "ccleaner" do
  version "2.07.166"
  sha256 "479d670d5e550932fcaabe5d6928185e98162464215e69f8838c1a31290d8032"

  url "https://download.ccleaner.com/mac/CCMacSetup#{version.major}#{version.minor.rjust(2, "0")}.dmg"
  name "Piriform CCleaner"
  desc "Remove junk and unused files"
  homepage "https://www.ccleaner.com/ccleaner-mac"

  livecheck do
    url "https://www.ccleaner.com/ccleaner-mac/download"
    regex(/CCleaner\s*for\s*Mac\s*v?(\d+(?:\.\d+)+)/i)
  end

  pkg "Install CCleaner.pkg"

  uninstall quit:      "com.piriform.ccleaner",
            pkgutil:   "com.piriform.pkg.CCleaner",
            launchctl: [
              "com.piriform.CCleaner",
              "com.piriform.ccleaner.CCleanerAgent",
              "com.piriform.ccleaner (com.piriform.CCleaner)",
              "com.piriform.ccleaner.engine.xpc",
              "com.piriform.ccleaner.services.submit",
              "com.piriform.ccleaner.services.xpc",
              "com.piriform.ccleaner.uninstall",
              "com.piriform.ccleaner.update",
              "com.piriform.ccleaner.update.xpc",
            ],
            delete:    "/Library/PrivilegedHelperTools/com.piriform.ccleaner.CCleanerAgent"

  zap trash: [
    "~/Library/Application Support/CCleaner",
    "~/Library/Caches/com.piriform.ccleaner",
    "~/Library/Cookies/com.piriform.ccleaner.binarycookies",
    "~/Library/HTTPStorages/com.piriform.ccleaner",
    "~/Library/HTTPStorages/com.piriform.ccleaner.binarycookies",
    "~/Library/Preferences/com.piriform.ccleaner.plist",
    "~/Library/Saved Application State/com.piriform.ccleaner.savedState",
    "/Users/Shared/CCleaner",
  ]
end