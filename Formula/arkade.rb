class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.12",
      revision: "08d2bff886c75fee770f5ce513dff28bcdc5e726"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59256e90d647016e86c9b8c9a429dfdd35607415d384c4e9cda30b6cb7d2113f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59256e90d647016e86c9b8c9a429dfdd35607415d384c4e9cda30b6cb7d2113f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59256e90d647016e86c9b8c9a429dfdd35607415d384c4e9cda30b6cb7d2113f"
    sha256 cellar: :any_skip_relocation, ventura:        "4dc30ea3d5e5db70117bcf3293c0ff6a5282a781d0c2b7de21936f2257fd78ac"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc30ea3d5e5db70117bcf3293c0ff6a5282a781d0c2b7de21936f2257fd78ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dc30ea3d5e5db70117bcf3293c0ff6a5282a781d0c2b7de21936f2257fd78ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f5b5c1b946506b9bc284623d347a8860cc822057263429880e9d8f1423ef99"
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