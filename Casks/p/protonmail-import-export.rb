cask "protonmail-import-export" do
  version "1.3.3"
  sha256 :no_check

  url "https://proton.me/download/Import-Export-app.dmg"
  name "ProtonMail Import-Export"
  desc "Import emails to your secure ProtonMail inbox or make offline backups"
  homepage "https://proton.me/support/export-emails-import-export-app"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  app "ProtonMail Import-Export app.app"

  uninstall quit: "com.protonmail.import-export.ProtonMail Import-Export"

  zap trash: [
    "~/Library/Application Support/protonmail/importExport",
    "~/Library/Caches/ProtonMail Import-Export app",
    "~/Library/Caches/protonmail/importExport",
    "~/Library/Preferences/com.protonmail.import-export.ProtonMail Import-Export app.plist",
  ]

  caveats do
    requires_rosetta
  end
end