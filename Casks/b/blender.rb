cask "blender" do
  arch arm: "arm64", intel: "x64"

  version "4.3.2"
  sha256 arm:   "32297d20fae74683052267b9171945712c0aeb8a499d8e677e44740d3e30a034",
         intel: "3894df9f3034b177c96a386ef017aa3a0e9cf1859fedbfe731a19438188ec8c6"

  url "https:download.blender.orgreleaseBlender#{version.major_minor}blender-#{version}-macos-#{arch}.dmg"
  name "Blender"
  desc "3D creation suite"
  homepage "https:www.blender.org"

  livecheck do
    url "https:www.blender.orgdownload"
    regex(%r{href=.*?blender[._-]v?(\d+(?:\.\d+)+)[._-]macos[._-]#{arch}\.dmg}i)
  end

  conflicts_with cask: "blender@lts"
  depends_on macos: ">= :big_sur"

  app "Blender.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}blender.wrapper.sh"
  binary shimscript, target: "blender"

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod "u+w", Dir.glob("#{staged_path}*.app**__pycache__")

    File.write shimscript, <<~EOS
      #!binbash
      '#{appdir}Blender.appContentsMacOSBlender' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportBlender",
    "~LibrarySaved Application Stateorg.blenderfoundation.blender.savedState",
  ]
end