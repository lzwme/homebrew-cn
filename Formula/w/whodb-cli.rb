class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.126.0.tar.gz"
  sha256 "c95b8567c2fa09a39ca76a934199244fd101d69a8c8abb0dbd0272ac4a410178"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa37cffb83faa40bed702b8b8994e8318e28524168c3f959e641405859df8e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3396c4c06995be091c6dca62dee007e8c374c4ac01a38ad73ea0ecd700b4c42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec94326c749b28177623b3fd17fe050efca5ddc418c5b4e606aa8defba36642"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ceb1aecb50bb8d4ee713773800a915a0c5e3abe23325b7c3dd0fde2b9f4bee"
    sha256 cellar: :any,                 arm64_linux:   "edffc518a226820d1c28e81a4c751c82c269e95216613895d07a96d1293ff7b8"
    sha256 cellar: :any,                 x86_64_linux:  "8846eb6a7e04941ed98891d0db837a18f5d4ebe3069e5e7f0e9ee581351981b9"
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