class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.4",
      revision: "944a86bc3a649fc220992df360d67a39a1b498cf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c3957591e3acac6b2236cc888cd24506c1381a53c7ee48e73a545e2511080c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84775b53426ec0e1288e274727e14198386f450d44db975dd15d7901dd4fe224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "551366b8596d3bcff47144e7047a48554f331f82cd6c7dc70d2918e321a579de"
    sha256 cellar: :any_skip_relocation, ventura:        "3506de25a8e2457df7058bbfcdea789e673e6aa53924d3fe9b4ada16ac1d724c"
    sha256 cellar: :any_skip_relocation, monterey:       "2bfe00ac81ad8858e933f893c84b5fee3c7c9505b66444cadc32e8614a4bbeee"
    sha256 cellar: :any_skip_relocation, big_sur:        "def702a37f6075e1ad86ecb19cbba70c30cca8cd35b92de51034de6d8374b6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e788c718aaa7d9cf1da7b445dc1b9ddd543a7f5a5201a96d9d5455e9cc4eced"
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