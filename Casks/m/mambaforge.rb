cask "mambaforge" do
  arch arm: "arm64", intel: "x86_64"

  version "24.3.0-0"
  sha256 arm:   "de7c7f229d05104de802f1f729a595736b08139c4ae59ba8ba0049050d63c98f",
         intel: "5455900cf1298f21333b7c0d1ec159952e1ef5426563cc97eb7e42053d608afc"

  url "https:github.comconda-forgeminiforgereleasesdownload#{version}Mambaforge-#{version}-MacOSX-#{arch}.sh"
  name "mambaforge"
  desc "Minimal installer for conda with preinstalled support for Mamba"
  homepage "https:github.comconda-forgeminiforge"

  livecheck do
    url :url
    regex(v?(\d+(?:[._-]\d+)+)i)
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: [
    "miniconda",
    "miniforge",
  ]
  container type: :naked

  installer script: {
    executable: "Mambaforge-#{version}-MacOSX-#{arch}.sh",
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