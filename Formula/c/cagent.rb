class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "f367074a4f124f50c51da2bc6c0420d9dca4c9f94db78e63aa7687ecf2988e35"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8da62e67cd002d38411a5d2a39088d3a2d6b61fed5e69bea44cf3b2f3c053849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4cc6a1406285c121e05d68764796840d97b0eea4636f6bcd8cda707d561f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a5a9c343d2cfb7a824c54a905ac81c21b6ac7c49b195aceb82e66873155c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "c24ec7b397a329525b759769411dfc06e73f943328cfaaf8f15f2415fb1974c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8ff6bc28e7f44603a0e2f1fb837bf562f35a9bfe7f705889bd96dd36ddb2589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b0779cd6a0841a1ca231bee72c9606c4c7f02a48a30e0d569278e635568885"
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