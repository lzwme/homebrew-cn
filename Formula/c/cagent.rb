class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "f51908d3e093b2fe684392b9f497efe98a3ab123ec132166ed04907f37955b07"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "297ad53c9d71ea5653621ad594997502e7d9f5ea8163396f27e40f087b35ad81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297ad53c9d71ea5653621ad594997502e7d9f5ea8163396f27e40f087b35ad81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297ad53c9d71ea5653621ad594997502e7d9f5ea8163396f27e40f087b35ad81"
    sha256 cellar: :any_skip_relocation, sonoma:        "957891c7833d814423c550b20ee73b25d015fbd7a0326e4c9cad832a073f121b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00818ffa3f061166bf961ddf96084b377c2879c91b759aee2ac30bdefcd2c0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e80e3768d6dc0498feca40a09e23835c8187447df820eb783892d5bc7d3e23"
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