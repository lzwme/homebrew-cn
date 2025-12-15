class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "a3e2ff53934730720a72d5fc2aad86c00c29a3aaf8f68ff126a4f801aca26b6b"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b491d3f54df3b1416fc5d655206d2a42afb56568b0509e979019fc46fe1a5b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "669c7d1afb1eeb1b23f2b05fe055e0b720b93994b569c92af3d119fdd9fd62f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f0d78cf4bb4450a39bb928353c6a0f87b74675dae1a78657c198af6bd08e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a247cc22762a0dc7db6d2a9643f3d55a3a90575e9a842e050a8a42cde3fdf63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b2e4c5f37289d7f5c468aced3356620deadc2dc24ef1341270d5a603c3f9a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b43479e4b085db2c984579d55e175ed78126c21b55f30f3b7bf68f9e67c922e"
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