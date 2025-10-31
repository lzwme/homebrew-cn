class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "7a906a8d164516e193833b324eb07b60fdcb1f26a8fbf23bba51b7ee4dea4766"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131a4b0f03353563e82a7605f2565012816ca52742937321d4c5739a4c0db253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "131a4b0f03353563e82a7605f2565012816ca52742937321d4c5739a4c0db253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131a4b0f03353563e82a7605f2565012816ca52742937321d4c5739a4c0db253"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f9cc7c4e10bf817ff9f3a1ad09fb4d6d5a66b5059983a370905e72153ce5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce3b4774a9cf76a67a8aebb621e4681dd4e8b7331b03f592a59b36ad55d8d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb19ab2009fe4011493b9c6cbc6ddd2937f445f200186c3cd622cea4a48069c3"
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