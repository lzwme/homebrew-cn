class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.91.tar.gz"
  sha256 "6b81566cebb7a3367484da772261d8f47cb1ecabbb66cf659fd47f8555a4e3ed"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c71934953bd1c8563be2c18cd280e48478560bef0a1639d2b815d1599dcc0673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c71934953bd1c8563be2c18cd280e48478560bef0a1639d2b815d1599dcc0673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c71934953bd1c8563be2c18cd280e48478560bef0a1639d2b815d1599dcc0673"
    sha256 cellar: :any_skip_relocation, sonoma:        "460a166ec1da5391bcfbcc3dc4f4c04a69b11f6777ed0665d13041fb58d7b816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ecec1d0b1f885237dd92b8fa347b186a05ba801b305bdc8ef679db0bbbd5bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2dd8f7aec5e2aac903e74e01619b1146459419e1b63c9d5e2b3b6c8f1c8a40e"
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