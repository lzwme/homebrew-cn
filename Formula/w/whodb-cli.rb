class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.122.0.tar.gz"
  sha256 "f7395155ceb9ab991a00cb32c5dcbc99854067d0c96f6fb80feb7f2fc4ca52fd"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d82e12c4fe8811434098b4a02d826a920dafea33103778e897d03f0b3c74a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862a0a5719945facb536712b402c2a043cefc8c9b2a83fb8f877ec4bde25623c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac549d09d1557c32a82c411ef5fab43115d41a74f7168754ad7907dbdafd97fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "385f411ee99013ab9fc71fa32dc9f69231295d55c5b6f2eb5e2d97cd428e7c3e"
    sha256 cellar: :any,                 arm64_linux:   "81957c7c21bc5f51abe5b1b7f850bb8f6df79e3b987e9839d0e41e1edbceab63"
    sha256 cellar: :any,                 x86_64_linux:  "cd79faae0bf1b0aaf9e662a017fd8359cc2f4ae412939347c5aa4c828c2e6af9"
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