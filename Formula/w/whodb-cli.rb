class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.111.0.tar.gz"
  sha256 "c7ff83a049c8558b9b1e887fb549bf2274a92148eadbbc61b61e1e8a755b1f93"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd4c10739f3d122d10bea19288ca17e259a7562da44a50a63db46a796444122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead3556aef431ad0a3c73ed907cf2818a39928986d0f2a1b166eaf7d4a30f34e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf23343cd6e8487817706067da065d004399cb0028e909ac57b2fb83dd15100"
    sha256 cellar: :any_skip_relocation, sonoma:        "f040bde61af00f1e8b56f3927eead1e9b0485618ceda23cb4e038d494765028f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d06cb5306947a8b8ddacf30a918824aac9f0040b48077d400666e8b4ab5091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0abdc7afdb50a8afba883438d26a259076e642c00d476169cd0169db5d83864"
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