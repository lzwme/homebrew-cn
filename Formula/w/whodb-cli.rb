class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.127.0.tar.gz"
  sha256 "dfa1207f62c7a78e2d796c395272932b443742e43f0faa30d1c826dfd07b19aa"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1050143e72a6976d6ddd3b71c94355e87a0d44e52d5609153159bf13bae6fc4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0c1f688dead9781bc4a3bcb512069344d7b1dc57151a8cd374a17603d2744e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4777273c8acb52eac0f43dda41cc0c1d0add886197ee317e943c0fbe8a7598"
    sha256 cellar: :any_skip_relocation, sonoma:        "67064c262901e81939dfa9e83f9fbe1507e7be38fc7c20f20404b11c8d0224c1"
    sha256 cellar: :any,                 arm64_linux:   "649ca07c37c9b6ae4276bc1d3c22786adfe3861d464ed358d77ab15d6c07808d"
    sha256 cellar: :any,                 x86_64_linux:  "e9139e5712b381025e2a539153eb4ff7b0a2c74349f3f860fa18741efa2fc146"
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