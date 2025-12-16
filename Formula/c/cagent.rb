class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "6b49184513511ad271102bb0159214e25367dc2ea5ccc71a752cbfdf99a4fe1f"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2ba6d14fea3161daae03a8c04c013b050b24c99b1145ab72c66ebb01fe6cff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6df291fea096d224f0cd0d36156ffe4662ae65ffd583120857ec8beabe1f5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9352abaf9177adb8b38f024b4216a486ead3e18eba4208c53f125e7551cdc436"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbfccb3a98b3429ba37410e0092b3994a7348f7a63ee1f69649ef32233e5ff84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e2a7a5278811ef6e5d2e6b9466d5c4c95e993411d249f901fade4f8be2997a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de44f78940ad357ba4634baa3c04e811efba47665e7a3bd057dad19e19a7de8"
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