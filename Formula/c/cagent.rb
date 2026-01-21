class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "cd25d346ba414446b5866dc836aaa01c3a4384fe6450f04c8ed886add5ef199f"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e0ad818f56c43c16c20ebb0dc6b6a07671c1a53181f2d47bce17c3f0883685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5229bd44e07643630e103d3900c9291cc4cf0e1c28a1f648b0c308c5bd8d16d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b443e515a95ef43e3c6b801e3219a11746924e902347fb9fde60b35fb2969791"
    sha256 cellar: :any_skip_relocation, sonoma:        "846e946394f1d0f907462c8805776b9696dc587c998e726d68ffa3f65ddd4b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3631246a8e088ed8f5e97f549ebe3ec174837c6e3b931790f0b5ea687fec5564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085b9a45935a993663d8d77d64c067cd7c9f58668f6b2473a5e6369cb89637db"
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