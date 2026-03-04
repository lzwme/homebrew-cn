class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.97.0.tar.gz"
  sha256 "92aca6b9ac4e1fb333ee046e2b26f6a33c06ad23c243eac65144ed2b527bf2dc"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5694a282491ea51127ce28571de2403017d1dfff789ff2b11b050377d614da9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c658a5900d83b8a357b27ca332bd5c6606370d13244e3d7dcefb655299acf17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b16a98c897daed50879298d9a1d34f35ff44b74dd97885f10cfa41fe0f06791"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd44d1ab8d10c0eb1f9078626bdace837d8fc4d108849bd95f952ed49a80f559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c8e177331adbdaff4b8145b8e1794213f1903ad8f4e1e80a3230baf0d39e03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ca75cc80d2f4bea845045ed6c44c08c200617e03765f2a71958aec378d71ac"
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