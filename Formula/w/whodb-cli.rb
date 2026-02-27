class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.95.0.tar.gz"
  sha256 "2d9962b5a88b465de7417207207ce2afb8b9023c9e5ac54b3cb2b0bebead4adf"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dd0ee501a62b9449e7dbb49ac94a983cc0608b8d613787f4b49a46941425963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca7b4994c059dbcc22da862512f7d62d06e6df667c579c921a17201d3c546de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170cb1c313ca633b05c0f5739059a144fa24259d129e5c3af3fc9eb4ca77f43c"
    sha256 cellar: :any_skip_relocation, sonoma:        "267933918e5c9a03aa56275067bb938fe2e03b6e995b50094ad2cb308061a16f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6b69bfb9ad787adf23ce5375ee172b17dbe537d109bc3471723255fee80cf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d1e01e4a7917ab045e9144db931bf36b386b2fa6a0c7d2818a08df0184d759"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -s -w
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end