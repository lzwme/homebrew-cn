class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.10",
      revision: "8f028584fc537ec79e0e1f70d7299ca5107765a8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88dbd0d09a5bd2de048274cb66d0417d2e9bce5be0f9d998ffd32eca089b7f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5265be28d076094cafcf4b352137d9f5d13acf35cdcc4d20d317f9dfffd50cd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62bc47b93499ee9021551b4567939bffc3a3cfd7e519b7b2c9d83f5df21d147"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0887f03818be77821487678fc822a7b3b9bd1e0cdb0d9710c3e9616e2b5e250"
    sha256 cellar: :any_skip_relocation, ventura:        "67f860b09645e7aa11b43991bfbd34405e734aa48dbdac9867f3ec795dc03aca"
    sha256 cellar: :any_skip_relocation, monterey:       "ada17a8bab62adaafebf82a8eadf06d3d873d3fdc364724fdc9d9f712c38c5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4880750ea13459cdaa3603b94457cb96f67e119bedcd2256731683f4ab37959a"
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