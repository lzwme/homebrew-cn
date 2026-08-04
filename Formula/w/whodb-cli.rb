class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.123.0.tar.gz"
  sha256 "9786e6cdfa67d903bf3a739a5d265a31d5205caa8dfad48b9e2d0c6f914c8350"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90b4ef7d25086b00dd000a7c0274065244e6b38d319aef10c41016409a79ff2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e9379a9f9ab40f520b0cd95131b2b09d80973f5762c0142bb53d595bcd72ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00ffee82c261ff076527fd5ffe016ff7a1eb5a80aa5ffb1e025d56e6852009b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70293360196686ed9142c495b8cde94b204b9905181ae472b0cc3b5ce4ad621e"
    sha256 cellar: :any,                 arm64_linux:   "ee6f8f9bbc5968a8db2c136899d4ecf62d5ca5669c511f80ed97afa6af29cd72"
    sha256 cellar: :any,                 x86_64_linux:  "dc4731bd8b2f8f141a680b2e012ed7380fd02a376583dcbcf606f7cdf08dab81"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
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