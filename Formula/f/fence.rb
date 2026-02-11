class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.22.tar.gz"
  sha256 "9882a2f9a5db4c8b890b72a60c3a6dab0ba96ccd984b8f15660e0f142e84ea2f"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef385a86eafb6b22074acd09d03fa87ecc84fa6d86cd3541d25b64f87c140cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef385a86eafb6b22074acd09d03fa87ecc84fa6d86cd3541d25b64f87c140cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef385a86eafb6b22074acd09d03fa87ecc84fa6d86cd3541d25b64f87c140cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "394e6eeec3b2459a7789ac69bd6defdc33038bb63473ef47dc66190629d4936c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa9d6673a99c8d0562f6cae307674fbada2055440a743ebffb68b976694d08ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8ccb06b1ddd3b9fadb09689fc08962f607a32b8ca76e03707a9d5e214dd6a7"
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