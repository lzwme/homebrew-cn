class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.97.tar.gz"
  sha256 "9ad7a93f397a3954923c4f119c67f4a8f781bde4d59ad5f027c67d0617013871"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f82ea946d895301c8747d1659fa58f0a7cb1cd943c60e8c2984a3c7e9de85a60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f82ea946d895301c8747d1659fa58f0a7cb1cd943c60e8c2984a3c7e9de85a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f82ea946d895301c8747d1659fa58f0a7cb1cd943c60e8c2984a3c7e9de85a60"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f0b5c52caa4c74e71cb580add6c0661ab75ee91fdda8d7a3ede07279d8ab1f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a89a4674a338608a5844d2b674fb27576877570ebb6bb47aa64aa71f67bb08ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24145c7fadda35f1722455230ed055ad06fd7f13801a9edc12a4d44b932e2909"
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