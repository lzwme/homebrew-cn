cask "libreoffice" do
  arch arm: "aarch64", intel: "x86-64"
  folder = on_arch_conditional arm: "aarch64", intel: "x86_64"

  version "25.2.1"
  sha256 arm:   "d0f8573dfc5d1a858061a9bc7889313cb6837db8a8f1b568d067ca156c03745e",
         intel: "88746b5e46a72ae964ed2275399ee0fb2a0712f6d93a30b151358ffa0ea8349a"

  url "https:download.documentfoundation.orglibreofficestable#{version}mac#{folder}LibreOffice_#{version}_MacOS_#{arch}.dmg",
      verified: "download.documentfoundation.orglibreofficestable"
  name "LibreOffice"
  desc "Free cross-platform office suite, fresh version"
  homepage "https:www.libreoffice.org"

  # We check the wiki homepage for release versions because:
  # * Upstream may upload a new version to the stable download directory
  #   (https:download.documentfoundation.orglibreofficestable) before it's
  #   released.
  # * The contents of the download page can change based on user agent(?),
  #   sometimes in unpredictable ways that break the check, so it's not an
  #   entirely dependable source for us to check.
  # * The libreoffice.org Release Notes page may not be updated in a timely
  #   manner after new releases are announced (whereas the wiki appears to be
  #   updated relatively soon after).
  #
  # NOTE: This needs to check a page that provides the latest versons for both
  # Fresh and Still, as this check is also used by the `libreoffice-still` cask.
  livecheck do
    url "https:wiki.documentfoundation.orgMain_Page"
    regex(>\s*Download\s+LibreOffice\s+v?(\d+(?:\.\d+)+)\s*<im)
  end

  conflicts_with cask: "libreoffice-still"
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