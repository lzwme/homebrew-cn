cask "overkill" do
  version "1.0"
  sha256 "e088b8a99ef76cffa56ec82b2f36e1461b974944de3d24996a43f503eb6c7606"

  url "https:github.comKrauseFxoverkill-for-macreleasesdownload#{version}Overkill.zip"
  name "Overkill"
  desc "Stop iTunes from opening when you connect your iPhone"
  homepage "https:github.comKrauseFxoverkill-for-mac"

  depends_on macos: ">= :sierra"

  app "Overkill.app"

  zap trash: "~LibraryPreferencescom.krausefx.Overkill.plist"
end