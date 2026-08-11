class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.124.0.tar.gz"
  sha256 "9971ec5a7cdafe61945617b21b3c47303e485c0a2dda215a008c4a44e7a2d38d"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2c1c7bde429639ca02de24b5467ed001d2d920a74692ba16d888cecdd4c3781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66c742fdce8680a082b77d34d3e0a944109860ceb704a5681b3c884cc87618b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9545a4ef4ceccacab510b0d7a5487c131629d052b0d27c5a932ba22234ca092"
    sha256 cellar: :any_skip_relocation, sonoma:        "26bec871f048cf87af8b661dc2e7ede8e02a1938ec43befffd2e051a65f4fcef"
    sha256 cellar: :any,                 arm64_linux:   "759a0153c2277ce7bbe082462e29a6b9d700cad97422ad0f3b241ee51332ff73"
    sha256 cellar: :any,                 x86_64_linux:  "7b863b7e8c243137d5979aa6b3a95a41de60fe218c1d38585c6cedd7a9bb0a14"
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