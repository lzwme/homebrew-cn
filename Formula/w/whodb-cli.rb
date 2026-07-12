class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.120.0.tar.gz"
  sha256 "fb2fb8b7eb23960666fa63a5eb04b1e950692f5ba175202d50b49d43333c82e3"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "064ff0c4115671d890d7cded1311549c4b80695431a011875ffb3b5b3fc0a32a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4190e5d71671dbaa36c8dc9545359cca4fe0e840d7a027aebaa634f5c7686802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32e3920a4100374ab82ea448556b85b6a1d340f468dfb04687faa114ae7c7c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3c6547b76f0d0bdcaecac65276699a5ebeb812b62050b9fe261bf50b2e5a97"
    sha256 cellar: :any,                 arm64_linux:   "1140f4a11317342657faa0376b65ef4f2f33379438c36466e9a2047668f49b91"
    sha256 cellar: :any,                 x86_64_linux:  "6c5403bbd12727ad2b96162c3f24cc43d198711c4257b54f3620c03c19a04811"
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