class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "f7649ebd82d9f6e04e7d829a0150e6df62a91f3696306cee3be33aa1e88ea872"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "728cb8cfe26c7eb3759e93f09f6dc2f424d00d567cd227efdbe02d3cd83a8ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d16185ee0510d32cfc6bc92de129c3675a4e1c19c8f777ff173f9db83d6074a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c608982de8bccfc8fcd5d1645d2bca7cb5b4ba9187925f2bbf2860c4cee7fbc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae30ed1c1ad7132774d86845fe1450e5405a33f11a1e254be43ab9d6261270a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42d6d659e4a1308b4330b0589d5c076375c418f3143c71b9e48f3d6c9d7d65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60c5284c78bf225bd8dd657b4b96ca1f9dc50f30f7a7c6cf17169068b83bee6"
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