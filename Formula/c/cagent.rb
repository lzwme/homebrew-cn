class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "d6d175e692579ee7406c9cd72beb4e7054cdb0108bc21b4a751cad8e6a8a30d6"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c83ea2385de86b27a747ef27e1f86f0aaae6dea21437a76fd492432e9007df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c83ea2385de86b27a747ef27e1f86f0aaae6dea21437a76fd492432e9007df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c83ea2385de86b27a747ef27e1f86f0aaae6dea21437a76fd492432e9007df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "913af8e3488612b8e2028b732e3f072e6b115ce2dc1d1345f9d2dfd387594dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19f38dcaf15ed92a90471e59cbe4f6d68cb7729ca2e8ac52ca8aa350a1b7fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84e203d880fdd732ba41201000aceaf180ac95631a0bee85fa3d99137e9bfe5"
  end

  depends_on "go" => :build

  def install
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