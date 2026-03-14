class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.99.0.tar.gz"
  sha256 "0b9ed146cde258cba268f857d3b853d89c4e9d4b31e97daa30db8d39b62dfc02"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7efbe03fea95d54c8041dc68e8cdd88ed89374e5c2ba2f9b7c3f5c24562dd4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b868861875af7d4ecceead72ade3542617fd8dfc123c1b217b754efbe7e3305f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edda2d9858dabab281610cfc742a50cee656b6036784822310662430ac28774c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e977f583ac832baf9890bf4b94a846b6a4b3dfdb9007e31a34f8ceef7c086adb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131ef1ff1674b45e4cf5c0791ed10463b7b75c59cc4d057a7fc59e5097cd13e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf3491890443a3d9298d58bc24b715a0ef49b7ff309ab583074f09d992c616f"
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