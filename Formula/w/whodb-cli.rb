class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.112.0.tar.gz"
  sha256 "90ba57f71c94d0d1282eb8f37e5f9ac4cca0a4664de3b535f593c0a3afca534b"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18c6aa6c65a796bbd044a11a4dc7450363277631a72bb42505dd5658dde7450c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0232c6c651f11777c32b7db775ee04cb5485776ed44643bcb5a71dd035b17902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb2d61cff312ce475bba72b2a602bfb6db80a628fdd9e7236ffb13fd561db5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ef6a589b00663c34ea5f81f27b0890197ef28d3d18346d6a1072e55227e474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d006bb2e0a2e74f6cdb985b0a789eb3da8c94bbc78de4b577da5691c717602ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22bfdefe6a9f110412030479a8984e30242c2bd8417c587296760ce98eb0495"
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