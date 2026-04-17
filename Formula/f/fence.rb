class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.48.tar.gz"
  sha256 "b26b8d50a83a81321e28c2c69c693aab3b61c6bb37728b6dc24a69c2b3799a73"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34b514df0138d0764ac6ec49a50dacbb9538accebbbf15095f374e1e1e05c371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b514df0138d0764ac6ec49a50dacbb9538accebbbf15095f374e1e1e05c371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34b514df0138d0764ac6ec49a50dacbb9538accebbbf15095f374e1e1e05c371"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ae0907960bebcdbcc9958d5b0efdadcc6558416ba5fec13026ffbb41f8521b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edace98fa85a573e37b67069d412b2b6592618fb0f21e3316dd989189512909d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51193f4b745f1cd2a61321311cd4b6c1ba61eaae715eb95799859ea1d3d65840"
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