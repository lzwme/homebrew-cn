cask "jmc" do
  version "0.3-beta"
  sha256 "b6e9303815d80948b80e1f94d797e1ee4ce1017940b236284930abc583ce6e41"

  url "https:github.comjcm93jmcreleasesdownloadv#{version}jmc.app.zip"
  name "jmc"
  desc "Media organiser"
  homepage "https:github.comjcm93jmc"

  deprecate! date: "2024-11-10", because: :unmaintained

  depends_on macos: ">= :catalina"

  app "jmc.app"

  zap trash: [
        "~LibraryApplication Supportjcm.jmc",
        "~LibraryPreferencescom.jcm.jmc.plist",
      ],
      rmdir: "~Musicjmc"

  caveats do
    requires_rosetta
  end
end