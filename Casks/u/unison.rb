cask "unison" do
  arch arm: "arm64", intel: "x86_64"

  version "2.53.5"
  sha256 arm:   "545b3b0818e671b7f966cd2f8d61df71b79f07a6cf7f180b969ddf26d50a0931",
         intel: "ff2ab52930f6642a8ca4c903a75ec6341ca8e886701819a1c39c678dfd492228"

  url "https:github.combcpierce00unisonreleasesdownloadv#{version}Unison-#{version}-macos-#{arch}.app.tar.gz",
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