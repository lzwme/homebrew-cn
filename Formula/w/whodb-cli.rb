class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.110.0.tar.gz"
  sha256 "6236cd312720b6c57e45cb8326ae64ebb09b5d90a160aa72d529ccc78aa96d8c"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bafb804b49929adc9ad4fd23d8a70d63a51002b216df12def1c72df638d3931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabdf0cece87e8da6843fd2052c3b2145a203151bb57e8914a45ba7b25dc9a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84b2f8b010578feb5728b2f6f5542ed37248ffb4e0aed2d3e6dd7aa2d5adbb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ecd69ccd7e33b636ae01c588dd9c2800a017ee577fc281aa8b9ea523d8f664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba45ac961c56bdd4573ff0dea1a5159bf7d546f352b5beb2fcad887199461d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bef0b943257e8de152025c5d1f631bf52f736dfc699e113fad365253bcf62da"
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