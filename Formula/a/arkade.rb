class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.131.tar.gz"
  sha256 "e21b25145abf3b853153a60598fa851279e2da86a92fa0e0d1ab9f25150ffbee"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4983ec1c1e4307ec5af8ecc0de36eec95aa77dd9ec1047461f717c22619f7135"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4983ec1c1e4307ec5af8ecc0de36eec95aa77dd9ec1047461f717c22619f7135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4983ec1c1e4307ec5af8ecc0de36eec95aa77dd9ec1047461f717c22619f7135"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c307dd3a657653329e5fc751672b1a7e36c3185c3a40ebcc5fdd7bc4e673576e"
    sha256 cellar: :any,                 x86_64_linux:      "f243b916491210f10989cc5477f2e27832196b485b9a469d50be55a3406e6870"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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