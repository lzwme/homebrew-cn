class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.18",
      revision: "e5350f45e402c4127761ad2c6e56cb66f0a5033f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14025ee8295c4c6212db4c6a9f1aca24076a4fe243866adf3ec99e89cb1fe5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f14025ee8295c4c6212db4c6a9f1aca24076a4fe243866adf3ec99e89cb1fe5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f14025ee8295c4c6212db4c6a9f1aca24076a4fe243866adf3ec99e89cb1fe5b"
    sha256 cellar: :any_skip_relocation, ventura:        "4df37174202fc3c7ecfb8caa6e44397396bb451da28534373c4d315870e8db85"
    sha256 cellar: :any_skip_relocation, monterey:       "4df37174202fc3c7ecfb8caa6e44397396bb451da28534373c4d315870e8db85"
    sha256 cellar: :any_skip_relocation, big_sur:        "4df37174202fc3c7ecfb8caa6e44397396bb451da28534373c4d315870e8db85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e0c5da82b932c10220128231ed1b9c241cfdc3228c882a27a71261e21146f5"
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