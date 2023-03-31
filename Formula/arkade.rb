class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.6",
      revision: "dc36fafb72b8308fb1cda3fb56beb5944d4630e3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342b24704f227c7696a9f38677713800308513a55299b5cc95aeb5fdf01646e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342b24704f227c7696a9f38677713800308513a55299b5cc95aeb5fdf01646e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342b24704f227c7696a9f38677713800308513a55299b5cc95aeb5fdf01646e7"
    sha256 cellar: :any_skip_relocation, ventura:        "84e1afb21f8d30021306fa04436b4cb43c51af843ff59867f6c27af2d2400a74"
    sha256 cellar: :any_skip_relocation, monterey:       "84e1afb21f8d30021306fa04436b4cb43c51af843ff59867f6c27af2d2400a74"
    sha256 cellar: :any_skip_relocation, big_sur:        "84e1afb21f8d30021306fa04436b4cb43c51af843ff59867f6c27af2d2400a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86c3629abf1bac8ece8a3ab193a029077220ae3654f12c5f96f74c83912882d"
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