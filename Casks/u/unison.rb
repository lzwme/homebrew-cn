cask "unison" do
  version "2.53.3"
  sha256 "c389e23927e43117851dd01b6fe681c8fa2f8c21bad599c24e2dfb8639f4100b"

  url "https:github.combcpierce00unisonreleasesdownloadv#{version}Unison-#{version}-macos.app.tar.gz",
      verified: "github.combcpierce00unison"
  name "Unison"
  desc "File synchronizer"
  homepage "https:www.cis.upenn.edu~bcpierceunison"

  livecheck do
    url :url
    regex(^Unison[._-]v?(\d+(?:\.\d+)+).*?(\d+(?:\.\d+)+)?[._-]macos.*?[._-]appi)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[2].present? ? "#{match[1]},#{match[2]}" : match[1]
      end
    end
  end

  conflicts_with formula: "unison"

  app "Unison.app"
  binary "#{appdir}Unison.appContentsMacOScltool", target: "unison"

  postflight do
    system_command "usrbindefaults", args: ["write", "edu.upenn.cis.Unison", "CheckCltool", "-bool", "false"]
  end

  zap trash: [
    "~LibraryApplication SupportUnison",
    "~LibraryPreferencesedu.upenn.cis.Unison.plist",
  ]
end