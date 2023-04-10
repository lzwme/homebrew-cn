class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.11",
      revision: "4f5998546a3b7b42c931ec89b17acfecfd193d21"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b20ed95a307c4c7ec11baeba379ec05ebc904bc1bf13bef20d9999be42b3a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b20ed95a307c4c7ec11baeba379ec05ebc904bc1bf13bef20d9999be42b3a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b20ed95a307c4c7ec11baeba379ec05ebc904bc1bf13bef20d9999be42b3a3"
    sha256 cellar: :any_skip_relocation, ventura:        "efbc93f1235e1e38a20ac614fd6405169e043f1f849fef1f391f9a83adf3d2ff"
    sha256 cellar: :any_skip_relocation, monterey:       "efbc93f1235e1e38a20ac614fd6405169e043f1f849fef1f391f9a83adf3d2ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "efbc93f1235e1e38a20ac614fd6405169e043f1f849fef1f391f9a83adf3d2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105642b5f816a39036560b8bd39659641c68a17f0b3480fbc029043ec1e071d9"
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