cask "rubymine" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.120"
  sha256 arm:   "6b8bd9c8ffeec01b0a907604d99cc77ede865aa9abf350e76957d9675ab8a810",
         intel: "97b154079ef326c9a3ce229129d7d220faee30f266954288f74bf6f27ee43942"

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