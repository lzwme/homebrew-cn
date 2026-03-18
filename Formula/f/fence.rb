class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "7c735eea9c197bd2785108e2d642a131c36b796d64d394aef7d5e3b52f071e82"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1f6b7043f1f3f047bd7898791d7dd4befbd06e7f5f66fe728c1253d8e805dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f6b7043f1f3f047bd7898791d7dd4befbd06e7f5f66fe728c1253d8e805dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f6b7043f1f3f047bd7898791d7dd4befbd06e7f5f66fe728c1253d8e805dd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc16b555cfe6d8348e8869a1438eed62c919aff73242f6787a191ee1f2dbfb7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f30183633b96632beddf1315a147be37c9332a64f5e9f8b157ffd2ec1604e009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441b8e7ea6b7f7d3d473e5f8fc39c4d3a4c72fe9cc40f46a11ea80084d5bb4e2"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end