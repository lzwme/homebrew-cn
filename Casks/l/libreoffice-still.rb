cask "libreoffice-still" do
  arch arm: "aarch64", intel: "x86-64"
  folder = on_arch_conditional arm: "aarch64", intel: "x86_64"

  version "24.2.7"
  sha256 arm:   "44e2229c4e26bdd7f9270a79e4da363a08f4de87b698a3806295e9e50cbb1b62",
         intel: "57b0af3ca12043ec3da6782ba58c094b12123549806451557f5a0a6e307a575a"

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