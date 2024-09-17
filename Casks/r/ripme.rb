cask "ripme" do
  version "1.7.95"
  sha256 "008201e406f401b27248277a4188f26203bb9da0170872de900125f8a6c8b558"

  url "https:github.comRipMeAppripmereleasesdownload#{version}ripme.jar"
  name "RipMe"
  desc "Album ripper for various websites"
  homepage "https:github.comRipMeAppripme"

  auto_updates true
  container type: :naked

  artifact "ripme.jar", target: "#{appdir}ripme.jar"

  uninstall delete: "Applicationsrips"

  zap trash: "~LibraryApplication Supportripme"

  caveats do
    depends_on_java "8+"
  end
end