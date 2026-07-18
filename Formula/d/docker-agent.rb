class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "a793a489973ef0c4ce9bc8008c3eef78a037ba2f99a7a72b2959c98b764168db"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8effedf9940e4504fa6bf261918528f9a31b9b51061223bc0d2e17dd9acc1de3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7683cff96ddbf2b4cd7560cb589ac123e9763533b783d4356f30efe7ee44f64b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2643b6884f674f3617ee919b532b3a0a9f40674dae137dec5fd2a65a5cdc876"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f08af9dfc9fe29e886239133225109a50906ac14cabdf76046a2f50f2bb734c"
    sha256 cellar: :any,                 arm64_linux:   "0db40e050cf7fbb46e7029c532e5ba32bf452aa49279596e20bbfb59f9856e60"
    sha256 cellar: :any,                 x86_64_linux:  "65bbf54a236934c2050f745f94b7d28e7f7270a3b28541289dbe9d0f3c4690bb"
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