cask "miniforge" do
  arch arm: "arm64", intel: "x86_64"

  version "24.11.2-1"
  sha256 arm:   "8bde418e8f5030b887535940cad3b531adf128a38b99e58ba6a26e68e9d5ad06",
         intel: "50a00997a0f08737d076e93f964dffcb51bc4792fd9371344fd244ab97bcf61c"

  url "https:github.comconda-forgeminiforgereleasesdownload#{version}Miniforge3-#{version}-MacOSX-#{arch}.sh"
  name "miniforge"
  desc "Minimal installer for conda specific to conda-forge"
  homepage "https:github.comconda-forgeminiforge"

  livecheck do
    url :homepage
    regex(v?(\d+(?:[.-]\d+)+)i)
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: [
    "mambaforge",
    "miniconda",
  ]
  container type: :naked

  installer script: {
    executable: "Miniforge3-#{version}-MacOSX-#{arch}.sh",
    args:       ["-b", "-p", "#{caskroom_path}base"],
  }
  binary "#{caskroom_path}basecondabinconda"
  binary "#{caskroom_path}basecondabinmamba"

  uninstall delete: "#{caskroom_path}base"

  zap trash: [
    "~.conda",
    "~.condarc",
  ]

  caveats <<~EOS
    Please run the following to setup your shell:
      conda init "$(basename "${SHELL}")"
  EOS
end