class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.118.0.tar.gz"
  sha256 "92a723a12920d89e49f60ff7bad8bb78d5fbd0085bfdf48702beb9ecd6785371"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a87504c4cec2657f1ae3e0b821a98b79582c3b23e1ac601e000e7b0fc5ee5bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11dc9a030b256b6a5585f139b43c6720402b02257f3f3c03efabf3a8c34cede3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e90d96ed37fb780a5c089cb9526e3d519d13a353b214786b640c0f60a028e7f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d47dfeed308ae67f5bdbfc2716017033e3574622160b0f49a2958415198cfd38"
    sha256 cellar: :any,                 arm64_linux:   "d544358812e858f34d494684d4348fd0d6565e76a46067015ada96ab6acb645b"
    sha256 cellar: :any,                 x86_64_linux:  "8aa90d71b7136ba2ea0904b936049d23f69fc37edc0c54d0a3da77ff42f7be3c"
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