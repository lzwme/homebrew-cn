cask "localizationeditor" do
  version "2.9.2"
  sha256 "6415313128c1dbbcc0432e7108c2eba87e558ad0b5f6a4a6c80243ceb97220ea"

  url "https://ghfast.top/https://github.com/igorkulman/iOSLocalizationEditor/releases/download/v#{version}/LocalizationEditor.app.zip"
  name "LocalizationEditor"
  desc "iOS app localization manager"
  homepage "https://github.com/igorkulman/iOSLocalizationEditor/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "LocalizationEditor.app"

  # No zap stanza required
end