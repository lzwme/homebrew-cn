cask "meshlab" do
  version "2023.12"
  sha256 "03e722dd4b7d9241d5d203bc1d15854ac3d122dbddee1835f0cdc65c537d53a9"

  url "https:github.comcnr-isti-vclabmeshlabreleasesdownloadMeshLab-#{version}MeshLab#{version}-macos.dmg",
      verified: "github.comcnr-isti-vclabmeshlab"
  name "MeshLab"
  desc "Mesh processing system"
  homepage "https:www.meshlab.net"

  livecheck do
    url :url
    regex(^Meshlab[._-]v?(\d+(?:\.\d+)+)$i)
  end

  app "MeshLab#{version}.app"

  postflight do
    # workaround for bug which breaks the app on case-sensitive filesystems
    Dir.chdir("#{appdir}MeshLab#{version}.appContentsMacOS") do
      File.symlink("meshlab", "MeshLab") unless File.exist? "MeshLab"
    end
  end

  zap trash: [
    "~LibraryApplication SupportVCGMeshLab_64bit_fp",
    "~LibraryPreferencescom.vcg.MeshLab_64bit_fp.plist",
    "~LibrarySaved Application Statecom.vcg.meshlab.savedState",
  ]
end