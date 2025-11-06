class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "fce17ba46f5dd11ae5f092ec263f2263ec7933ba0074ea9dc7d9de61cf82112c"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd0e26bf459314d69a686521615b7009973b408cddb4df05ca40dda735ebbf45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd0e26bf459314d69a686521615b7009973b408cddb4df05ca40dda735ebbf45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd0e26bf459314d69a686521615b7009973b408cddb4df05ca40dda735ebbf45"
    sha256 cellar: :any_skip_relocation, sonoma:        "034b27da16affbcc69da322fe790ce53e87c0433bdbfa61892e5485e1cfe5493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36a2fe2b123f4f7b5e662c06460c9908c1a003b14c1b728feff8336341ce19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbb6fd0ff6ca94c30937b4eabb0140692624706e9cb257ba8baa755b24367a8"
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