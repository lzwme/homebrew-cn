class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "0c6d15e2c95d67abb8e3c9e510fed2d602aa56650f54fbb9c897d7b90befb24d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e2ed383c070b565668c73d06f2ca61b93d50c024380292f2453d576278cb6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e10e7f92faf7801952b7ddc3796fcb3f3e675c7fba973d635bc3c2001030e284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae0d038cfdc531aee7fed4788779f0f7e12a44668dac0643eee4232eecd6d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2c70f817c780c745bab4869e691b3f7335320d1fc2d5a4cb5dde88b0a804aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55be8f8e71328375abd4ef9430ecb14315fb66a20e80dfc85a85ae87444a0f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91349f4c9ac90d1b4ff6dad9540b6a76942965d8cf27629e58762b6dc79065af"
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