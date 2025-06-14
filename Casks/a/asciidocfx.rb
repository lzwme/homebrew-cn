cask "asciidocfx" do
  arch arm: "_M1"

  version "1.8.10"
  sha256 arm:   "eb4510935a93df580633a7508be2c719f827a889ea6ded72f2a5956ba3b1a9a8",
         intel: "2b50145239ee80c7adf053bbfc5df481580da14e5e5fb0703a4adc8c2fdb45ea"

  url "https:github.comasciidocfxAsciidocFXreleasesdownloadv#{version}AsciidocFX_Mac#{arch}.dmg",
      verified: "github.comasciidocfxAsciidocFX"
  name "AsciidocFX"
  desc "Asciidoc editor and toolchain to build books, documents and slides"
  homepage "https:www.asciidocfx.com"

  no_autobump! because: :requires_manual_review

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