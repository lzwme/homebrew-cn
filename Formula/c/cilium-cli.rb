class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.4.tar.gz"
  sha256 "52281571d4f86cf466bddaa942680032dde0fe1ec78079c6d100d1175f55ceca"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb25be8064aaba57e06d8575ef451e0505a2d9dbb7d52aee8296c958c534337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1235b3d6b4d136aa7e696d8ffe51ab2f4af84812fc81b6f41ce555b3a70443a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88fce25b2890c653de933dc5b04be57dd7fdc8f9361464a241c1b943110b62cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "34ea28366bd979c1d8f01c878071e117219c1571e7bb1e336c43ea881bca8dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "52c94e6e26ea4034c07db7b87dcbffb449d948804d8004b7012770b46f107121"
    sha256 cellar: :any_skip_relocation, monterey:       "4670242e1f266928d1b87719a516519641ef3660170b2035fdf0f04c83cc34e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7664fb3d355649c5bbfcbbb6751ee0d8da6a8fde4b426376ddf66e0bf87ec81c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clidefaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"cilium"), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end