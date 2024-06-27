cask "libreoffice-still" do
  arch arm: "aarch64", intel: "x86-64"
  folder = on_arch_conditional arm: "aarch64", intel: "x86_64"

  version "7.6.7"
  sha256 arm:   "17686aff42734ea4feef08e1189bab3011220000f7784061314c1ae9e5942531",
         intel: "42d2eeaeee7bcb0e76e9decdcb8f5a4beebf133ad31f7d42a5e96ea770860110"

  url "https:download.documentfoundation.orglibreofficestable#{version}mac#{folder}LibreOffice_#{version}_MacOS_#{arch}.dmg",
      verified: "download.documentfoundation.orglibreofficestable"
  name "LibreOffice Still"
  desc "Free cross-platform office suite, stable version recommended for enterprises"
  homepage "https:www.libreoffice.org"

  # LibreOffice "still" releases are the stable versions with a lower
  # majorminor.
  livecheck do
    url "https:download.documentfoundation.orglibreofficestable"
    regex(%r{href=["']v?(\d+(?:\.\d+)+)?["' >]}i)
    strategy :page_match do |page, regex|
      versions = page.scan(regex).map(&:first)
      uniq_major_minor = versions.map { |version| Version.new(version).major_minor }.uniq.sort.reverse
      next if uniq_major_minor.length < 2

      versions.select { |version| Version.new(version).major_minor == uniq_major_minor[1] }
    end
  end

  conflicts_with cask: "libreoffice"
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