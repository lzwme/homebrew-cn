class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.118.0.tar.gz"
  sha256 "bc645aee3bbd35f3996b7f2a1b6fa1509394fdf8506ad144348a0cc07e2de24d"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e4566d1255b0f8ab85c9a84b24acbd2c9361fde08e9f3bae61cf7d6c81a9412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22757e1622d4f8e94b909d0944f8a2f571d336bce9045f92f7dae4c08a9b6398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cfb8e51512ecdaad4e64df03f2babf933253a98e40e6fa75d91fa94c8c5b077"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ad28992f299f53340bb99d6f31ded58b7af8ea43681d4a631cbbf319fe7438"
    sha256 cellar: :any,                 arm64_linux:   "9919422ada2fb3182e4d987cfca4a2906175052e56006f067b8b694d44cae67f"
    sha256 cellar: :any,                 x86_64_linux:  "1789cffaacd18425fb6e06ddb2dea3b473be1d2652093a9c4b91a530152b2c0e"
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