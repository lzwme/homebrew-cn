class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.94.0.tar.gz"
  sha256 "e15f8197397f050b6ac7f93f1dac085866bc63c3e10711e1d0ebd95154286b8f"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8b949f52ffc403f4b50fc67107b214aee2bf6811fab2745c62f8d3ea8739fde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f76cbaa43fe993c08410f2744924d7dd5227c4cf6230162dfcffe6376a0c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b0679b423475e1ae9692a2c9d92320b9d43fa43ffa6958e1e8e4f3f2828048"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73fbd509d87a9dba777ee95c3c3da5745956d3aef0163d5433325d15fe13655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4505406e5065d799f4b3ed75bb4c00d463dca1aec2e76f51926960cb6e50f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e0c9da0a878c079cbbe44df3ce36d70cfb5af28ed0f6c8fee06b95d45ca25b"
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