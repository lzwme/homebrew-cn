class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.98.0.tar.gz"
  sha256 "33b1122812df69364799ebb25dacecaaeecd23a5cfdae6c956aece3e018cb6c8"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86481e68b53e4e0ef838bbb953ecddd19166292ae02e041e281e75e584c6a95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e96f3204704770d5796d909eb9657cd819ad50b0936a47015b266fe841dbcac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eaa2e84c56d861f5422f8252cb251488b45a9f10a8c2111d701d99e775e8be5"
    sha256 cellar: :any_skip_relocation, sonoma:        "68848e90b33203bcaa9a31e58c44bfca6a73e664e6d71144833133a708c8336f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2021c26e359bceb4a859bf71920d771339c5d4beffb13c11e911dd9ad9d7c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5eb62894e5bf5f39bd953bf1cbde38dac8914f8eed93c61a927bc3817e186f"
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