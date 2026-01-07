class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "e91167ce376088a9f4f1b493e8d162e9f1086266d364ecfea9e13dfe638ca583"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d193dc8ae72995772fd4489fb7557e629ab6490ac5d5c57417e3d99ad938d9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963cb3115b1758f70d1423ded8803b56ecf04725a6b7788bcd33a5586d24a216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14fe7ae4323457da4df2a8557fcf0e6d64022bf61be98d9b3fe73a449c6398e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dee0f20d89668221a6121938bba67dfa1feedafe88c6b4cc2c0410bbcbdd61eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4dff8dbf1a76ff626252e0271b342632e0c1c389cf28045e34fef52e30dc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec03e90e854e71943a7294854c7592e9f0e84a3ac4025ecf23d13dba5759799"
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

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
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