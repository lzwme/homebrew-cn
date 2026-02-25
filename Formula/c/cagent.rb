class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "6dcde2ab491349bc5db6a6270e2333fc8ee726e38c7b8720043fbb461906c8fa"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1237f7ded79c34d3a5ef9982df67b0b494883bf55de112c74fe1792a94680a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ce41f256ea4864c58773b00911fafc7fea54bd477fd0c70b4662d6f7bdb5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c254143d20c99847b9a42a7144ae623db30361c38b22cda7e8e41c82b6cb2274"
    sha256 cellar: :any_skip_relocation, sonoma:        "a469a96dab444d39a713906cae12e19eb229355894ff28e39133730159fdb59d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc262f7dbd072f57482222f4ad6e84e409210c8846a88b4e4065b20d6c88d88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efd6b0242d07610aa9a08eec397c60937854e0fb0b227c0920fe55227854dd93"
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

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end