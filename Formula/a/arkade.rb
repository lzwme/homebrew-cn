class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.70.tar.gz"
  sha256 "89a7362a6ea0a2d4bb533c1c068a23dbc4bf14ca6e345fed776d31a48020700a"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa849ecbb95065c0e840d45d8a5831d206ea7876f48b63407249967942809910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa849ecbb95065c0e840d45d8a5831d206ea7876f48b63407249967942809910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa849ecbb95065c0e840d45d8a5831d206ea7876f48b63407249967942809910"
    sha256 cellar: :any_skip_relocation, sonoma:        "395b8766bafb701cc15cebc37bd238c1afa0b5eca670225b61f1d1ecaa2c50cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a02cade675c72dd13822639705cb0333df56afbf51348e9f76be74f15d4d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f249f5aeee49b4c1b61754898b86afe74c6f750b8210893483835f8994632ece"
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