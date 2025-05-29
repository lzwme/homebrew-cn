cask "rustrover" do
  arch arm: "-aarch64"

  version "2025.1.3,251.25410.170"
  sha256 arm:   "552145a2d550cfcb2dc59530605dbe4af179102a99dab4b69acb80d9504d0ef3",
         intel: "2ed48a8d1f0afb13a5a2d59a1f478128bff406028f82290db1f9b2847a1e6ade"

  url "https:download.jetbrains.comrustroverRustRover-#{version.csv.first}#{arch}.dmg"
  name "RustRover"
  desc "Rust IDE"
  homepage "https:www.jetbrains.comrust"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=RR&latest=true&type=release"
    strategy :json do |json|
      json["RR"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "RustRover.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}rustrover.wrapper.sh"
  binary shimscript, target: "rustrover"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}RustRover.appContentsMacOSrustrover' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsRustRover#{version.major_minor}",
    "~LibraryCachesJetBrainsRustRover#{version.major_minor}",
    "~LibraryLogsJetBrainsRustRover#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.rustrover.plist",
    "~LibrarySaved Application Statecom.jetbrains.rustrover.savedState",
  ]
end