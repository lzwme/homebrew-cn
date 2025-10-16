class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5e5b972618534ebd973def8644527fdba040936b628cf6d10e1d07bf9aa2509d"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db27e81a8c3f0539b7344b642534a76d0e0f0c564c2a626a631b1abda2fad24f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db27e81a8c3f0539b7344b642534a76d0e0f0c564c2a626a631b1abda2fad24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db27e81a8c3f0539b7344b642534a76d0e0f0c564c2a626a631b1abda2fad24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "32915bfd50e9868417f58782da989a7af1611b72fb6d97fd95b092de1e283a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "249b423df67d084b945e4c6002638a10bd185c57279e8fbdd217aba5dbb08b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6033746c5761f25dba4b7a7b21eff89032ac0a86c6faf635bfd54b75e72547e7"
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