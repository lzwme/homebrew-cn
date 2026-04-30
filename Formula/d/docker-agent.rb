class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "2fb1211a0e86f4badeab2ae320bc87672d119a090d1ef9ea72657a769ddc6b59"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32bcc1a65fa9b22355fea155d3f50d3abefcffce47d2574ad286072516db4246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5149789fa50265640a3fac02fb13d4b3ac90e529763507985c9dfceb52eadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b5b9e5ac42c2cf4ef73b752132bed410af2870c5789ea7972667adcf7c1894"
    sha256 cellar: :any_skip_relocation, sonoma:        "857dd92dc66c6790fa09bbe7eebea296fe16a940b89659302bd3340b196279e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f473a42a96ed14eaca13a8a7bff409822bd7dcd84dea35805d5028411d4e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ff1c48632c69385607e943f10f811eba63b2c2aabaaccd9af5365048d92a22"
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