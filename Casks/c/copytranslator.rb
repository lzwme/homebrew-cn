cask "copytranslator" do
  version "11.0.0"
  sha256 "b05cd929b0e285d0b5300f71a575b20287f3c814043138ce04e1bcfc4d1dff96"

  url "https:github.comCopyTranslatorCopyTranslatorreleasesdownloadv#{version}copytranslator-#{version}.dmg",
      verified: "github.comCopyTranslatorCopyTranslator"
  name "CopyTranslator"
  desc "Tool that translates text in real-time while copying"
  homepage "https:copytranslator.github.io"

  livecheck do
    url "https:github.comCopyTranslatorcopytranslator.github.ioblobmasterdocs.vuepresspublicwikimac.md"
    regex(%r{href=.*?copytranslator[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :page_match
  end

  depends_on macos: ">= :sierra"

  app "copytranslator.app"

  zap trash: [
        "~copytranslatorcopytranslator.json",
        "~copytranslatorlocalShortcuts.json",
        "~copytranslatorshortcuts.json",
        "~copytranslatorstyles.css",
        "~LibraryApplication Supportcopytranslator",
        "~LibraryPreferencescom.copytranslator.copytranslator.plist",
        "~LibrarySaved Application Statecom.copytranslator.copytranslator.savedState",
      ],
      rmdir: "~copytranslatorlocales"
end