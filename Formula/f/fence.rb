class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "28940480f5e5565d4b03b0c9d7ef9e7d6fc68dc7bdf0e93b1e1b3c31628c57bf"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7728d455bf16f4fec61fb893c5fe4acdebd1d59d721e93cce548dd4e3d2f7b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7728d455bf16f4fec61fb893c5fe4acdebd1d59d721e93cce548dd4e3d2f7b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7728d455bf16f4fec61fb893c5fe4acdebd1d59d721e93cce548dd4e3d2f7b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccd9d08aeb5ef2f772a8c6c6fe93140b655c502978b481a26ba4acd33fa1ca83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402c6e1df13cc6e6c5bb92d9098b068792a7bcd868aeff0855d8e424d65c1af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c455e81ff75a1c3abde2de945a2abbf3f9d0df66128f4b46abb3c960dbb03061"
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