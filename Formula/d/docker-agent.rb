class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "2b56c70bdc8f896234dc5252d0912690481d63ef5f4440d93494c6af97edc203"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71c2684d6e7e126c8de8bcbd5dfe822dc7f8c90f70f5d536daaa72ce2e30fe5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d5be7fd13bba33b51f545617739ee998858b6d0e8935cbc0b16ea8bc6348bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8264ee926d715c66030475697a9df224bba4baeae6040f3fb9d4ff27678bc355"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdd28b5c45e13eac7baa9ccc3cda8983af80bab623b097c531e01a0ff336a2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e23c67361783eea32d6d4e0fd7965fee769aa9abd5b044345a3b0bf1aea7780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe8040bee3624caf36b8f34be0c878721851b17a2840071508e2a89bb0054f3"
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