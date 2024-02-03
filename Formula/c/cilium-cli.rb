class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.15.22.tar.gz"
  sha256 "e6bd80d865cbe0bb17ef08bb26e2b3bf223350edbb35f3e5d30b543baf22a6b9"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f37482345fb3c31c08f51d7139b679cf99791fd40e290f5200bd383ecf4333a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c489dcd0be870c783dc1bbdc67cb99a45adfa466dac220a9d63fc262976588ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ddc3b69e1b38251e7690f621bf878fa5f450d6171bad4a3f369c4804822a5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "db87438d9d36126af12d491b39f0fe096c63231b8f5449b985acdbed3b9547da"
    sha256 cellar: :any_skip_relocation, ventura:        "6f84ef02fd89ed2c54d06f71d7c361ed765469637bf35027514e59af5bc1a9cc"
    sha256 cellar: :any_skip_relocation, monterey:       "72d38a22cc60cc88b9f1d0b4fa8e9ab3eec5c509d905207c84bf2ecb793768ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3926f567d3330f92d7286fc2b557c89a3cb6bc33da6a6bcadd38b11859e25f38"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clicli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin"cilium", ldflags: ldflags), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end