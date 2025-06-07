cask "rubymine" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.122"
  sha256 arm:   "1da265fa947d5d1cf3075495414b9e65ec519a5bd9bee5ca2fa7df67bafdc352",
         intel: "059d3d4c089b9277089bd7d64b8f6eedcf039fe791cddc694af434a1c5ad88c8"

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