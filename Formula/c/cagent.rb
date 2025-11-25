class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.23.tar.gz"
  sha256 "28c6b2b2413e8eabf3b4ccbe1955f8f698dc45ba1e2c9f5116446edf501beedb"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d54317a6120c65336ffd2fa06beb29a3fb8576840951f2a5f0f6bbdf9a54371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d54317a6120c65336ffd2fa06beb29a3fb8576840951f2a5f0f6bbdf9a54371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d54317a6120c65336ffd2fa06beb29a3fb8576840951f2a5f0f6bbdf9a54371"
    sha256 cellar: :any_skip_relocation, sonoma:        "927dd6dd7682b0beff163747b309126a2124e2ed31afcefbe6996fa0c8e24cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321dcee7c638ea19ef3cc53d4316899d771fb79cdba52891133031c83e6e9381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6be5224720814802bcb3cab906db59214fa892e06b7a7c208fcf16dd45f16d0"
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