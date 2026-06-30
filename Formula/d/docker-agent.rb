class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "f546912916315943f7eda467e1d2c31a40991968f66792e7d83294d5ebd197b2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e77734780a7293d2c9a9a16451dcd4a7a36239fead2b86fe43333770b8e37ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd07fa1882df4f658ac5b51e09c404b8e295ecff0e13c6bb0c12cf3402c4556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64999cf17402c5c8faad5581922fbd79fe9979d261764b9525c4a6f8023c352c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd32e5a35b57ef1d45ea1a96eb80666fc83d67d5335805f7635647ffd8daabc"
    sha256 cellar: :any,                 arm64_linux:   "febdb109b664bf834859a717b1c9f8fe034072c5915048bf0a32430cd10c3bbb"
    sha256 cellar: :any,                 x86_64_linux:  "f64d4d5890d637a8fef4b422841f8063cd5f3d0262fff740854382b5acaae193"
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