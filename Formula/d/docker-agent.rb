class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.125.0.tar.gz"
  sha256 "ef4bcc1f465a923dd2e76fbb7c14b4473e8362569fa90fce84c94462f5fada75"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a861183cd3f2aecd038a3bac552d01d432c6532827296f4fffbefe05aa7ea205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dc980d58db30cab857e7c5dbb86cd5d964d6d527014c18d5af754c7e89884ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2d58378e2889f0bdf289744f38a5bbf8e3f731150c7a9c39d9f45c2193ed501"
    sha256 cellar: :any_skip_relocation, sonoma:        "1936fa2a65c20f632ce54915d09a107d5d75e7eb6b554bf015b6a9590a4b5004"
    sha256 cellar: :any,                 arm64_linux:   "4a0a1d737a38e405630112a87055b5712c6b40e338f50948b08dd7dc2d83fa1c"
    sha256 cellar: :any,                 x86_64_linux:  "f4a3418d56075713b95b627a90f628abd366b4ca30d887c9f0d5b3c3283787a6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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