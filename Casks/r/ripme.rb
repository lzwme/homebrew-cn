cask "ripme" do
  version "2.1.18-16-1342b621"
  sha256 "204ebb7fb4f822d503f9dd1350a5703eb1f62aaf4a280da37cf3310472170afc"

  url "https:github.comRipMeAppripmereleasesdownload#{version}ripme-#{version}.jar"
  name "RipMe"
  desc "Album ripper for various websites"
  homepage "https:github.comRipMeAppripme"

  livecheck do
    url "https:raw.githubusercontent.comRipMeAppripmerefsheadsmainripme.json"
    strategy :json do |json|
      json["latestVersion"]
    end
  end

  auto_updates true
  container type: :naked

  artifact "ripme-#{version}.jar", target: "#{appdir}ripme.jar"

  uninstall delete: "Applicationsrips"

  zap trash: "~LibraryApplication Supportripme"

  caveats do
    depends_on_java "17+"
  end
end