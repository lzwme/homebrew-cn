class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.103.0.tar.gz"
  sha256 "8b6ff9afe4b544c15d3d0022be550c2d4945c46a85d82505b8c37820152b392e"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32d704836bdbfa2cdbcc5011301d04859cec673832edceecc98e429eacb16f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11caa1c2c81635347943bfe104c154a141d50264c055a6da5a56d24d8a9a4eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915b8b99f3ef3625c732d78e26d0ef52594c493e9d06c78b4a64ddfe75aa0340"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e760e3cc400933735d7a6e3cf3cdfe0044a17c4275ec24e632ad675fbad5367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c2b246abaca790bea658d0f35092f5cf34ba597cc1fc426e46008f38975250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d850a31786a4d30298af3b84408471d3de3628a494a0d6be06e9866ed94df89a"
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