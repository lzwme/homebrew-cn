class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.79.tar.gz"
  sha256 "f7edc076b56807b4701c5f2c82455e51c115a3c71170f317428df3785a569d59"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c01efd563acb0a67531b2b80861c6d12a6e8431574b8e936faaae7a10d20996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c01efd563acb0a67531b2b80861c6d12a6e8431574b8e936faaae7a10d20996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c01efd563acb0a67531b2b80861c6d12a6e8431574b8e936faaae7a10d20996"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d610523eadc5d544bd8c658c14e8158ae6f2292b059f7d84bb61b0c14cdf3a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e53a43f99f9e5d941bd89fdb33b7122b1f3af486dbe5807954306b42a0dace01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5df6e2fcd6b784209f063da0485005535e81190e3cdb5ebf04656c4581a7ecb"
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
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end