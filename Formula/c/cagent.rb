class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "10590922787180de42f90caec3e9807a672daae39a6718e8098957418cfc187e"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39c776b090ddba178b8f593430183fae7de505081d685518a03cbefc0bdc0371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fceb7a1159d0290204377b50e718e0c467a128637cb5e6852a22f9c81e92ccce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "501335920c4a3abd8933d1f972e0717affdaac2d0d0ca206c02a85b4086e0daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "640c752672eded5b9cce9b0d562c7c496cf6115995a5a090fecfb562c9a97c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "363eccbf7c12a43b7a2a41ce2fd123d777bba3b549582e3e4866f21ead034dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411171b2604070bddfecc32946b854a5f0f8824d3d474aa05dd6402036c8f60f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end