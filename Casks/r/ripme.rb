cask "ripme" do
  version "2.1.17-32-8f58eb41"
  sha256 "dc9a91f9b4928ed03611808200deaf027a3910e4fe6c9ceeda7aeed363750758"

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