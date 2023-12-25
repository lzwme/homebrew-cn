cask "asciidocfx" do
  arch arm: "_M1"

  version "1.8.6"
  sha256 arm:   "cc3912340f5da0f3b39eda6b384e4e94985fdcef9f9af9ba978f6904029ff632",
         intel: "2dcceeca0232652ef60e79ba3e9ed730e086050c8c598c810acded4c8c989956"

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