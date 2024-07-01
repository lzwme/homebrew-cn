cask "asciidocfx" do
  arch arm: "_M1"

  version "1.8.10"
  sha256 arm:   "aa3790f8d250136ef8025a4862d64a188640bc4b835ec3857401d2b5eec95b79",
         intel: "81fbb4ea8fd781a62e1e92fd936d038c919d337cdfb0509f24f91d27a29db146"

  url "https:github.comasciidocfxAsciidocFXreleasesdownloadv#{version}AsciidocFX_Mac#{arch}.dmg",
      verified: "github.comasciidocfxAsciidocFX"
  name "AsciidocFX"
  desc "Asciidoc editor and toolchain to build books, documents and slides"
  homepage "https:www.asciidocfx.com"

  installer script: {
    executable: "AsciidocFX Installer.appContentsMacOSJavaApplicationStub",
    args:       ["-q"],
    sudo:       true,
  }

  uninstall script: {
    executable: "ApplicationsAsciidocFXAsciidocFX Uninstaller.appContentsMacOSJavaApplicationStub",
    args:       ["-q"],
    sudo:       true,
  }

  zap delete: "LibraryPreferencescom.install4j.installations.plist",
      trash:  [
        "~.AsciidocFX-#{version}",
        "~LibraryPreferencescom.install4j.7853-9376-5862-1224.24.plist",
        "~LibraryPreferencescom.install4j.installations.plist",
        "~LibrarySaved Application Statecom.install4j.7853-9376-5862-1224.24.savedState",
      ]
end