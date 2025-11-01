class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "3c3403f0571844b66aaccb597d3b5f715edf9099dd3b3b0302e6ed61be658683"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cefa0e0b5a53b5928eb4a7427299658f8c135dc007da4debbb6f4b8a5511252e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cefa0e0b5a53b5928eb4a7427299658f8c135dc007da4debbb6f4b8a5511252e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cefa0e0b5a53b5928eb4a7427299658f8c135dc007da4debbb6f4b8a5511252e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a41fe06fee92a33e238d642075fcf09f486832f05763d7b1d37bc78b86d375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c8bcfcbb81df8e270fd1a4ded34886018f3b83329a2ee6d1e76bf47174b7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf238e7157cf44b3d606ab1131d104c67aa2f97e096f1895ffdbf8f3041d5b0"
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