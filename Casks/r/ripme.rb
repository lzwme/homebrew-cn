cask "ripme" do
  version "2.1.16-4-02372e85"
  sha256 "0fdf9a774e6d2f7504118134142008e42b19dafec7176fe4236e82045c3a8e95"

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