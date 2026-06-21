class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "fe7951dac2aa6d2fa4b5871a72fa7603c74831981a78f7be2b040ab16b5d1fca"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e34c66a1e861285882854ece574bb1839d5d278f32f7c991222a89e9be0131b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd8990b83711fb18703ac466856297fa84b4b26c601b692d7a46c2131c7130a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a6ebb0e45b1b7f117d7b5921da90961feaf50e4130d84913d84cf22aa444b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9fb6d9bef43cc9c48e3959c062237080fa6fe28bdbea71ecfa7bf7cfe31b4ab"
    sha256 cellar: :any,                 arm64_linux:   "4b0b9db6b704c32fa03cbda33db5877f9113bc2eab5eb31e01ae43d0e55b7408"
    sha256 cellar: :any,                 x86_64_linux:  "335ea84b214e2ee986ae569fbd260a8dec9544dacb30d8abc971cdf524a96c15"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end