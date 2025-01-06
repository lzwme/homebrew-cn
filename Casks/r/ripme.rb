cask "ripme" do
  version "2.1.13-7-fac3f8ea"
  sha256 "196e0048aaf742ac44840675b46907502a144a0b3d27402e7666c29e94aea185"

  url "https:github.comRipMeAppripmereleasesdownload#{version}ripme-#{version}.jar"
  name "RipMe"
  desc "Album ripper for various websites"
  homepage "https:github.comRipMeAppripme"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+(?:-\d+-\h+)?)i)
    strategy :github_latest
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