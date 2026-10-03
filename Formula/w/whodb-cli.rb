class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.134.0.tar.gz"
  sha256 "7581d72837fcfc181f0f7c6a6235429278950da6360c3ca62026b5bad2f3a1b6"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0837a5f94693db32becfba41b63ce2040e07f2a0d489b2f21b964733ce6b7594"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8b5b1a29b07ce9b1b1ed2ba65bd7379b7d82f8a230df8812898d70aab1d41ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ac72a30a186d925eb74bd74a30858dd7e7b9d10c55617534cf347df7852bb77"
    sha256 cellar: :any,                 arm64_linux:       "af3214061cc266dcf8b4780cbce1389c227762f3975def6934341f956df45fe4"
    sha256 cellar: :any,                 x86_64_linux:      "f4724eda50b784bef9dc9ebc23f806505d315a60e5c4280140bf6ba386f9447a"
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

    system "go", "build", *std_go_args(output: bin/"whodb", ldflags:), "./cli"
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end