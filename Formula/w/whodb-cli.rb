class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.135.0.tar.gz"
  sha256 "b1dc1a43c96d2ddc6743b13a2e492976d0f44a5bc9545bcc9dcf3a7aef7d7c9d"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99093c953fad11fd875ce3efb09b01ea73c0de5fe86256df96035f5e0fe37ee7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7650f7359d76af921a247a652c82a2b7d86c43e24c0eca81b7a1e39e4cc018bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c00d46599ae65f0b10c521132cc6e2708c7314ab73a47789417d2db679889ed"
    sha256 cellar: :any,                 arm64_linux:       "26648dc885e998ee6711c144c36ec973d678dd9566010c8fe6dde022f911cca9"
    sha256 cellar: :any,                 x86_64_linux:      "ae7930a19b8f297b8fa94b38a360956bd767107d5413548a6b3c84fd1e967f73"
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