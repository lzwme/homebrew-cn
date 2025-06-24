cask "rubymine" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.47"
  sha256 arm:   "06e9d70dd8f885526ff778df9c611e1e3b334a7cf313f769c7544936462056d1",
         intel: "e0487e51ce73cc6f24c77cde6c5ab5104f6528b3c14b90488fae1845023b822f"

  url "https:download.jetbrains.comrubyRubyMine-#{version.csv.first}#{arch}.dmg"
  name "RubyMine"
  desc "Ruby on Rails IDE"
  homepage "https:www.jetbrains.comruby"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=RM&latest=true&type=release"
    strategy :json do |json|
      json["RM"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "RubyMine.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}rubymine.wrapper.sh"
  binary shimscript, target: "rubymine"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}RubyMine.appContentsMacOSrubymine' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportRubyMine#{version.major_minor}",
    "~LibraryCachesRubyMine#{version.major_minor}",
    "~LibraryLogsRubyMine#{version.major_minor}",
    "~LibraryPreferencesRubyMine#{version.major_minor}",
  ]
end