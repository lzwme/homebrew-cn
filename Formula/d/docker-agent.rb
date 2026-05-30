class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "db5067383820283389037f02eebb8c12783e7c57a2a83f43133584b272587699"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da5d50f7ef560e33845a8879c7fded2b1099e66c447c3c39aa3a669bb66c1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd521ee5993f1451e832555108cc24bdea02f103c6fd5c645306a8710076ef76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ff3402e3a987cc86e86df6cfd42e4a8416f2c6628b653053d768a5e435d4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1198bfb6c9dbfd5d91474f007c14912b2f46f0358043da4d3c5b51301de43e8"
    sha256 cellar: :any,                 arm64_linux:   "76bc283d372bfdc595f3500483cb4cb23888b792927e61eb99d58ddfcc596453"
    sha256 cellar: :any,                 x86_64_linux:  "7ed16d505268ea57bd7a966ffe4ed342c5c322dea8c1308605f46eaf9f5eafae"
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