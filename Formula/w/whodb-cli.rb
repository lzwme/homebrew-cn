class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.101.0.tar.gz"
  sha256 "72d6090f07e3c06379befc2fa5057948ad5d8ed7c83013386b381e7b3088863f"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d848eeeabb0a77287add1f7731ffce7d65be56b2b058de87acc7bccbc34c65b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81eee40934676fd1a1a09a2fd5559813513836a96a6c7c55d943b8b459d722a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46501265b92b34b8b20c39052a063f17cb4c6e00b7bf72b68ef6baf522876d4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a281c3e886017d9a04198751940b150fb9370608861c988dbd27c3b505e1d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d0a9a1c87f5c0062a86efba7e24107126a7b74ff2b62335dc431ac47d8597b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f420ed0c4eff361619fcb86065ec3ed87349e87959ccebe11f0f5898d2b055"
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