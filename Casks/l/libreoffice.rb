cask "libreoffice" do
  arch arm: "aarch64", intel: "x86-64"
  folder = on_arch_conditional arm: "aarch64", intel: "x86_64"

  version "24.2.0"
  sha256 arm:   "b0be01214255d533084f8f54d50171a54f0a2f526760b93ad322a75c1c6e0a33",
         intel: "0f4f7f3faa89fa763ca7eda3e8d52ed9f9781a670671c13e94d61ae598ef7292"

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