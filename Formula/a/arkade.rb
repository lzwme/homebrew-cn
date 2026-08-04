class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.115.tar.gz"
  sha256 "10b48f74e85146f7a3c5c0f42b0d6a7fbde7587c2f5c0c1531339461b7b4e71b"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1e66b0858cb2bbbbe56a50def5a650b94f27baa2fc0a9f743c7979c4429e2e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e66b0858cb2bbbbe56a50def5a650b94f27baa2fc0a9f743c7979c4429e2e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e66b0858cb2bbbbe56a50def5a650b94f27baa2fc0a9f743c7979c4429e2e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "baa3d7f46c262ddb25dc2ea4e47b7bd0661d515774e707f88bc33e6162f44bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78708a3618de9e4890db68f5d0fcba7361454f564aed59a9fea67e19f13bb695"
    sha256 cellar: :any,                 x86_64_linux:  "0857e597dcfc3c617d968eb48f3c7e5597691642200500f1bcff4e5c565e73f3"
  end

  depends_on "go" => :build

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