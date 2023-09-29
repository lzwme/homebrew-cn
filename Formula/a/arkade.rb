class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.8",
      revision: "0659e1c79dfd7804395d00994fee163b0eb6d872"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31090cb98b764be9c208e95481e1ee00b1f97fc53999ab18f6caa78e418415ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a6ed506e3b97e347567c29006d9496bb2e1e42e608c7f9b761ed2f63f0582b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc339a3b01870021990b883b237b2794242400cf1a330db5c4b8a6b84bbe66f"
    sha256 cellar: :any_skip_relocation, sonoma:         "307d65b9635dfcb052bc970b5134b144c674d273ece50329ce19b06d5766b743"
    sha256 cellar: :any_skip_relocation, ventura:        "61a9b1f1fa3a3311204f0eb0bced330b17c075717af94f754d7bdc0a0de5450f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad57c320ec24c327bfbc7396d7ac1e3862ea05171869d43ed7850317b66ef6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a08c4e04504692cef8d6a9a87a8f93c018855123136a8434bfc61a464acb926"
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