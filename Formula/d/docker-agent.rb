class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.117.0.tar.gz"
  sha256 "92afe0a96b22b0c7ec6305d002778dad396c668079a594580de7b4131bc8d921"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "200d8369510dc70c28bd4df5f5b500e8cd7de1a6549a88048fde24fb58026502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7a56ebc7cc5e2fd812211a9fc398e998c447265b260ca053b3c98cb813b03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936d134c7295d547bc50633de278811051ed08908b2ad0a678a842f478925fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b891d355f9d9e1aa06e5c8a6cc4673f7bdc40c5151766a26c20d5e0f238dc7df"
    sha256 cellar: :any,                 arm64_linux:   "4eaee09e421e576369f6411589e2d34225f1060b01619a2afafb9e457d5b7313"
    sha256 cellar: :any,                 x86_64_linux:  "00fcc227c8bfa354a540f84e933318cae671637de38456bbb70d67a929af48c5"
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