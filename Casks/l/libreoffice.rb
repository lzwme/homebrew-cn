cask "libreoffice" do
  arch arm: "aarch64", intel: "x86-64"
  folder = on_arch_conditional arm: "aarch64", intel: "x86_64"

  version "7.6.4"
  sha256 arm:   "44d141603010771b720fb047a760cb1c184e767528d7c4933b5456c64ebaddb2",
         intel: "58ecd09fd4b57805d03207f0daf2d3549ceeb774e54bd4a2f339dc6c7b15dbc9"

  url "https:download.documentfoundation.orglibreofficestable#{version}mac#{folder}LibreOffice_#{version}_MacOS_#{arch}.dmg",
      verified: "download.documentfoundation.orglibreofficestable"
  name "LibreOffice"
  desc "Free cross-platform office suite, fresh version"
  homepage "https:www.libreoffice.org"

  livecheck do
    url "https:download.documentfoundation.orglibreofficestable"
    regex(%r{href=["']v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  conflicts_with cask: "homebrewcask-versionslibreoffice-still"
  depends_on macos: ">= :catalina"

  app "LibreOffice.app"
  binary "#{appdir}LibreOffice.appContentsMacOSgengal"
  binary "#{appdir}LibreOffice.appContentsMacOSregview"
  binary "#{appdir}LibreOffice.appContentsMacOSsenddoc"
  binary "#{appdir}LibreOffice.appContentsMacOSuno"
  binary "#{appdir}LibreOffice.appContentsMacOSunoinfo"
  binary "#{appdir}LibreOffice.appContentsMacOSunopkg"
  binary "#{appdir}LibreOffice.appContentsMacOSuri-encode"
  binary "#{appdir}LibreOffice.appContentsMacOSxpdfimport"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}soffice.wrapper.sh"
  binary shimscript, target: "soffice"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      '#{appdir}LibreOffice.appContentsMacOSsoffice' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.libreoffice.script.sfl*",
    "~LibraryApplication SupportLibreOffice",
    "~LibraryPreferencesorg.libreoffice.script.plist",
    "~LibrarySaved Application Stateorg.libreoffice.script.savedState",
  ]
end