class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.5.0.tar.gz"
  sha256 "c07b7af9331f2d28467178eacc6f4e3b91895ca1f16e41e7c3359a04a6bb52ad"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7508b933b823cd24f32a485a8f4af05c5cc81930f91bc76b4d5233102e7300ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded8b115662d3c7f5cf3af136f72a75f66a8152252b24c55cf6c2825baccb731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48c4b9553cf35e56bea74ecafab2f508f044018055555f3009d37e8c7b4929af"
    sha256 cellar: :any_skip_relocation, sonoma:         "581b3cfafe3f607fb2c76c0e2e1d91961aa256a44dc575f86dea645513c7aee9"
    sha256 cellar: :any_skip_relocation, ventura:        "158ee65f7bd444c1b9ab4348810abe1525b05743d8f783f33423386ce2c49887"
    sha256 cellar: :any_skip_relocation, monterey:       "44edcb9c9af24bdeeafb630331d0ea4d7919f1d856c145e5199c00514e3e9e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac9224a2ed82b6693aa9f98da3af4e4d163ff6ce3fea43de75b749433444c99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system "#{bin}scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
  end
end