cask "vine-server" do
  version "5.3.2"
  sha256 "9cbea2f972b235029c9d68b15004e3d401668c3a24e86d60719eed26f2cc5a71"

  url "https:github.comstweilOSXvncreleasesdownloadV#{version}VineServer-#{version}.dmg"
  name "Vine Server"
  desc "VNC server"
  homepage "https:github.comstweilOSXvnc"

  livecheck do
    url :url
    regex(^v?(\d+(?:[._]\d+)+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Vine Server.app"
  binary "#{appdir}Vine Server.appContentsMacOSOSXvnc-server"
  binary "#{appdir}Vine Server.appContentsMacOSstorepasswd"
  binary "#{appdir}Vine Server.appContentsMacOSVine Server"

  uninstall delete: "LibraryApplication SupportVineServer"

  zap trash: "~LibraryPreferencesde.uni-mannheim.VineServer.plist"
end