cask "apk-icon-editor" do
  version "2.2.0"
  sha256 "11d08b197f303f638e3663f0f14e0a5fb3587e64b07d4691c63d5d18e90460a0"

  url "https:github.comkefir500apk-icon-editorreleasesdownloadv#{version}apk-icon-editor_#{version}.dmg",
      verified: "github.comkefir500apk-icon-editor"
  name "APK Icon Editor"
  desc "Editor for changing APK icons, name, version and other data"
  homepage "https:kefir500.github.ioapk-icon-editor"

  app "APK Icon Editor.app"
end