cask "google-japanese-ime-dev" do
  version :latest
  sha256 :no_check

  url "https:dl.google.comjapanese-imedevGoogleJapaneseInput.dmg",
      verified: "dl.google.comjapanese-ime"
  name "Google Japanese Input Method Editor"
  desc "Japanese input software"
  homepage "https:www.google.co.jpime"

  pkg "GoogleJapaneseInput.pkg"

  # Some launchctl and pkgutil items are shared with other Google apps, they should only be removed in the zap stanza
  # See: https:github.comHomebrewhomebrew-caskpull92704#issuecomment-727163169
  # launchctl: com.google.keystone.daemon, com.google.keystone.system.agent, com.google.keystone.system.xpcservice
  # pkgutil: com.google.pkg.Keystone
  uninstall pkgutil:   "com.google.pkg.GoogleJapaneseInput",
            launchctl: [
              "com.google.inputmethod.Japanese.Converter",
              "com.google.inputmethod.Japanese.Renderer",
            ]

  zap trash:     [
        "~LibraryApplication SupportGoogleJapaneseInput",
        "~LibraryLogsGoogleJapaneseInput",
        "~LibrarySaved Application Statecom.google.inputmethod.Japanese.Tool.ConfigDialog.savedState",
        "~LibrarySaved Application Statecom.google.UninstallGoogleJapaneseInput.savedState",
      ],
      launchctl: [
        "com.google.keystone.agent",
        "com.google.keystone.daemon",
        "com.google.keystone.system.agent",
        "com.google.keystone.system.xpcservice",
        "com.google.keystone.xpcservice",
      ],
      pkgutil:   "com.google.pkg.Keystone"
end