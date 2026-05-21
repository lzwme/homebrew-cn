class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.98.tar.gz"
  sha256 "2e894b6de4664cb1e01d4975cf2849e8a999332404e76256618d08252a2028a3"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce70d4a33c1f610ef5a7792c181e50395f05103e410d8c7e633aaa551f7fe059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce70d4a33c1f610ef5a7792c181e50395f05103e410d8c7e633aaa551f7fe059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce70d4a33c1f610ef5a7792c181e50395f05103e410d8c7e633aaa551f7fe059"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6e2304e8fc8efaa11d79ede57f9f63120440fc831b4947011c8f6df86b3ef43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721518f816ba6d2e0ef313ba91a247d4ba6197e509a2efb838e35fc9b9d7fba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d24039db2dc07a1626542fa3bfa7d77aa561353c67f8ab48b707567ed1d9766"
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