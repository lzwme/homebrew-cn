class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "dc0b1fe82c14c5f227636ff5dbb431642f16fb619b93fe5a80fa57dfe6b267f5"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d06d196e93b8b117c58e90ed3ecb8b91aa5e2210a2771eded2c37b7453d4b727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98436de7b89fae97807292e423884abea0d1ca790b760396d45522e32839f285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "209acce7d78365d647a8ed0c2ed31cb7529ca377da5f44cf55be3661c8ad581b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44d22f07f1d13f34673070d580848b204386fb94a136c36e039315ccece8d1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bed023ec94b38fb0f699a7f3058b87d9bcfce42abb69866d78a9701dc76f7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8c6612a797e9ee33b0b441124cc5c4f264caf44140befbf0378e7439b5c7d80"
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