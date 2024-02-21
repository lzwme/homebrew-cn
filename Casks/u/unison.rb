cask "unison" do
  version "2.53.4"
  sha256 "1c3e18eefcd63ced1cd4bf43015cb6c0adac9824466de2c5cf7d598b3a8901fb"

  url "https:github.combcpierce00unisonreleasesdownloadv#{version}Unison-#{version}-macos.app.tar.gz",
      verified: "github.combcpierce00unison"
  name "Unison"
  desc "File synchroniser"
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