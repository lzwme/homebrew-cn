class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.17",
      revision: "b8c2f3b8a5e95332ea226315809da70c2ab1e015"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d83fb409f78b7c41b31f8277cc05a4632621350f540b91dac279fca3ad7448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d83fb409f78b7c41b31f8277cc05a4632621350f540b91dac279fca3ad7448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d83fb409f78b7c41b31f8277cc05a4632621350f540b91dac279fca3ad7448"
    sha256 cellar: :any_skip_relocation, ventura:        "2231120f6af46b6b7af6d28e72017bbcd55518342b5a4e7e5d8f37395b2bffb0"
    sha256 cellar: :any_skip_relocation, monterey:       "2231120f6af46b6b7af6d28e72017bbcd55518342b5a4e7e5d8f37395b2bffb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2231120f6af46b6b7af6d28e72017bbcd55518342b5a4e7e5d8f37395b2bffb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3404bbd0e0b3e321ed43922bb83393f478353eec4234e2ac75058c01eb72d02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end