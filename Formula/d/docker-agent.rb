class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.120.0.tar.gz"
  sha256 "d43a95c9623ed2aa94218064c4ead436881e168add2f56b67253461aea09834f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7d01b1e4559d994871d0ca961a4b489b7631728165817e87bec65046f5201e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d05004c80cb46fdb79da2765803797899a9abe11fd613191d7bb8b7949c47cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d63d5be5f518ced554d5a627cea24960e294657377d5ee39f004f257e5e91c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6331b81621bea352f5af20d46b120dde6f91f25a94c546cf77f555ee3ad7f896"
    sha256 cellar: :any,                 arm64_linux:   "ca983fb60ab3b6c11a177957203b58af577bf0cf97588ca5f741a011bc8177f1"
    sha256 cellar: :any,                 x86_64_linux:  "b01e34d5f5491942040d01a7e15704b8a0d3653556845e920d7aeca05a447d6e"
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