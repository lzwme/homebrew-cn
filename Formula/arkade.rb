class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.21",
      revision: "96ad0bf90b725502597ee244bce27de8469dd794"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cef39af00021b2dca90f2be7a21ec77787e846db89fbf4797ec66e7df2b25183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef39af00021b2dca90f2be7a21ec77787e846db89fbf4797ec66e7df2b25183"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef39af00021b2dca90f2be7a21ec77787e846db89fbf4797ec66e7df2b25183"
    sha256 cellar: :any_skip_relocation, ventura:        "4531d0d3311f2128cb2c3668084d95701d38db34085588511517c53b069253a3"
    sha256 cellar: :any_skip_relocation, monterey:       "4531d0d3311f2128cb2c3668084d95701d38db34085588511517c53b069253a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4531d0d3311f2128cb2c3668084d95701d38db34085588511517c53b069253a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61d9ff1fff8367dc6210c7c676c7d849c6e7e52c2e24a9e8053990c8bb11e47"
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