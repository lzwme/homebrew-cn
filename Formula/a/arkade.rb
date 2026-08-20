class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.121.tar.gz"
  sha256 "40b49129896efc89982636caa0c22df6f49fb427d5d689d5e2344151c2e24678"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97060a9a80c3bcc0392989bca9011513bbb9741f4fd50fe592c434ea6d3e982d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97060a9a80c3bcc0392989bca9011513bbb9741f4fd50fe592c434ea6d3e982d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97060a9a80c3bcc0392989bca9011513bbb9741f4fd50fe592c434ea6d3e982d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b84dd578998a2eb127432402e552c5f39b75debb9623cad9d14355c8cbfcfd68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb3c4625b10cbbf660fb37ba6826c569061a67640a27c0faa06d396c592f66d"
    sha256 cellar: :any,                 x86_64_linux:  "f04be4eae458590b40e4f2e5ff217f98a8eae98ce7de2b4b0ed1a12dcfd296c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end