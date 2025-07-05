cask "pensela" do
  version "1.2.5"
  sha256 "f6029a8a876038835c9045e75a05367f4f6f63e7ff6a9f11e4921a0ef9559c6b"

  url "https://ghfast.top/https://github.com/weiameili/Pensela/releases/download/v#{version}/Pensela-#{version}.dmg"
  name "Pensela"
  desc "Screen Annotation Tool"
  homepage "https://github.com/weiameili/Pensela"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-02-11", because: :discontinued
  disable! date: "2025-02-11", because: :discontinued

  app "Pensela.app"

  zap trash: [
    "~/Library/Application Support/pensela",
    "~/Library/Preferences/com.wali.Pensela.plist",
    "~/Library/Saved Application State/com.wali.Pensela.savedState",
  ]
end