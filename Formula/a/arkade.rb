class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.107.tar.gz"
  sha256 "42c203605e869b5c6706992bf15128636f642dab1f134017bd8b9010675e5080"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e4fcb7e8902b481b2f7761f1cd61ec89c4cb280349e9c9e80eff49cb85220ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4fcb7e8902b481b2f7761f1cd61ec89c4cb280349e9c9e80eff49cb85220ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e4fcb7e8902b481b2f7761f1cd61ec89c4cb280349e9c9e80eff49cb85220ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3eb0433baa1b09e9dff00166e33aecd075b8c93edea5d8c2c8fc9c67920ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3ff5a5e87d8febb34a831c45063d5bba9d1259d7ef9be796917a1d0df68572"
    sha256 cellar: :any,                 x86_64_linux:  "82a1551cb483d43515eeb89cdafe0fa3dcaec3ae8eba8637a9925a655a01729c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end