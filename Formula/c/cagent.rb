class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "2e59b7354ebd5048588c78536c026c008b230cf1c02ec85d6a16dca7fe2b5471"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f29374ca13216da688964d82fae1eb907a1e0552e15803052face6399a8aa7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f29374ca13216da688964d82fae1eb907a1e0552e15803052face6399a8aa7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f29374ca13216da688964d82fae1eb907a1e0552e15803052face6399a8aa7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "76243f7ec158666e19d32b7925ae801dfd7ddca17be14621919c8d0285de928a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8203635d398f3285f0ef8f1db745f8af020d0d3408d22b4f82f1c4e9e6ade4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71503ceef6ac46fd71f48af638d692342787cf4d4649d7fe9e4e6539893d7a31"
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