cask "nslogger" do
  version "1.9.7"
  sha256 "52d36d45c2abb89f27ca5c3e14a4569cbf7052a787788b31987ccd227da2e5a9"

  url "https://ghfast.top/https://github.com/fpillet/NSLogger/releases/download/v#{version}/NSLogger-Desktop.Viewer-v#{version}.zip"
  name "NSLogger"
  desc "Modern, flexible logging tool"
  homepage "https://github.com/fpillet/NSLogger"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-02", because: :unmaintained

  app "NSLogger.app"

  caveats do
    requires_rosetta
  end
end