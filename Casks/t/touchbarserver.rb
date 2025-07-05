cask "touchbarserver" do
  version "1.6"
  sha256 "c3adffbaed14d12feaf5300995f78e63fbbc2a99733f76549f5a4b071ce86a82"

  url "https://ghfast.top/https://github.com/bikkelbroeders/TouchBarDemoApp/releases/download/v#{version}/TouchBarServer.zip"
  name "TouchBarServer"
  homepage "https://github.com/bikkelbroeders/TouchBarDemoApp"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-12", because: :unmaintained

  app "TouchBarServer.app"

  caveats do
    requires_rosetta
  end
end