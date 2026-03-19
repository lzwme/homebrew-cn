class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "5e3d489cf2602d135fc2e910734e88a0d02d63ccb5197a73f6b028690495018e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fcbb93f290033ed05f20e97a124cce2eca3e6cfee8eaf7d69d844da1bfade69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981ef19a3bfbdecf99689b9c3f39d9e72240018ae6096b8521fbba9b65359f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc63ecdc8948d735f8e1a1e3b15434c36bb302b41c8abed6ba90b8d01ac63e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "81759bc128490e2632616f80a77dedae59346fa0695f113e5e50fb27271d67ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3f14f2cd339f683255299d9af18a167433b694a2f45fa1212fc65bd7a65ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f639e79777c676251ebe75752e1bcf1841ac82732027e8719bfbd9f8beb4cee"
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