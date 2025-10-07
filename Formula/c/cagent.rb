class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "6316edd4b4abe023e1a4a1713ee2516629edd511fd89fff63d1c7bd7821a8d38"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab666c286ec026645a0f0cdc3dff89eff99fcc4bd3d00745b30cffc2860e5de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab666c286ec026645a0f0cdc3dff89eff99fcc4bd3d00745b30cffc2860e5de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab666c286ec026645a0f0cdc3dff89eff99fcc4bd3d00745b30cffc2860e5de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c710bd1df11a74d22d2620205fbcee8273a27851b60985a8f653c16ee14c3a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143727a340cb87fc8ca207b14cbb3ad764cd94e0b83b2d2609bc1565b885ad3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3d18cf9c52f0bf08ed67eaf9827b9693b675f0015cfc017cb77f5f1ab85855"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end