class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "f4b6224ae600bf1cd31a0de56ee87679230c6e1807e93a5c45e8b884448f7b5a"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5693d3ae41649c88c26017d80dfdeec08d14c6c46db23cab26454f005934b511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a065bd515c06dd8d8b0c60983d88c42f357f4f91d28d8835f7c84c14838c45c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4c651e1cbabe6d9f764dbd29444e4704c35a1d21eaefc196f1b2fa724d4080"
    sha256 cellar: :any_skip_relocation, sonoma:        "fff9129381a4f89f19710a32d97d43f002a4cf510b0467209b751a5c32473ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb897e2d1c85579de01f32bf7937458af8cb68a2d9fef0413d3016e632616ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f23af62bac0f92f1e0ffb793151b4b78a38bc86e26f9dbc2fc0a437cf4b4971a"
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
    output = shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end