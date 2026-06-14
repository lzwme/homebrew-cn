class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.114.0.tar.gz"
  sha256 "74df01186109d418dbe8e5c8a2366ad29c73db6da0546832c3242ec72593f4fd"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49b38b58f28876065f082ac9ceeefe3808729a9a252744e4e5870556a51de737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a91f0ddf9c68d309a9fbe7eaa784da60fadfc03247c951772e902ea9fa10015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603d993ce52c9e2c64ecfd9e3960535c21ad897797b35a8752a5cc253e1603a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa20c6b1ced0d32687dc78a47385aed297334f3ed8043e2d24f044562f045d0"
    sha256 cellar: :any,                 arm64_linux:   "6f7c0cf6187254d2f95963b82a2412e7a48cefc09c637700302e8b83ae9e5437"
    sha256 cellar: :any,                 x86_64_linux:  "4f47e17fd55fc6c2e065fe29e9aebb0cf4f68ae7e238f41684c806b7094c6504"
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