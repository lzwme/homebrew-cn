class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "909ef6d0807567854eaa1a0c94e77492a157924c4f7cfa1f355ebb7e9a7b7bbe"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d6a24acbe0072da4e2ec639f5ef4f6cd82ab4ce6357d04b7e708a2d96846b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "037b4027ac5d7b7ca61c3f7bb0732d9bfae17d06bd3ac285fb1188f9d0984661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fece824875a6c6b6914936a691a33291c2d33291c27ff4d7194d0c87395abcfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1625871df3401143fc38e58a863860350812371bd942bd1a09e22c8fded8e33c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c62702e28b839c6075a81f69635a9ba4aaae18d393d2798e1525c2290171c11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540ff980c39edece8054ecc6251093534f78075f03e2e8b11e3b35f5437fd019"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end