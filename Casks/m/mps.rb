cask "mps" do
  arch arm: "macos-aarch64", intel: "macos"

  version "2025.1,251.23774.423"
  sha256 arm:   "cb2aaa6311252a655ef55f813d3dff78890c2a10cf0aeff885018c316390486b",
         intel: "1ddae8569c8a96beeb5e85d20f1eed9115ace532a1154b5624f526cb49ddeaa8"

  url "https:download.jetbrains.commps#{version.major_minor}MPS-#{version.csv.first}-#{arch}.dmg"
  name "JetBrains MPS"
  desc "Create your own domain-specific language"
  homepage "https:www.jetbrains.commps"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=MPS&latest=true&type=release"
    strategy :json do |json|
      json["MPS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "MPS.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}mps.wrapper.sh"
  binary shimscript, target: "mps"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}MPS.appContentsMacOSmps' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportMPS#{version.csv.first.major_minor}",
    "~LibraryCachesMPS#{version.csv.first.major_minor}",
    "~LibraryLogsMPS#{version.csv.first.major_minor}",
    "~LibraryPreferencesMPS#{version.csv.first.major_minor}",
    "~MPSSamples.#{version.csv.first.major_minor}",
  ]
end