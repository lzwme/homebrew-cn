class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "bbbbec38619171c4138cb716b43115e3f2d447b95a89a54dae4c1a7232283568"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d14b8a31482c3985e1fb262aa507b84286ca38d1d8b8805317d08ffaa82ec576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "600a7f6c6b3a26866e922b18363d05f084619edbf4211f8cb665edc3f543e331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c2ed1c494f6ce69baad3cdfe1394c02d7ad4e5a357f5a2afd5f7ee2670f6a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e8997b1946886e54d041fba4dcfbfd45a680f0f7b1330818085ab4c8ad1323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc81379dd02eadf397776291e7e4aeba02d3f1010a204a03a677b74d4af61941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a26e1211080bccfc3e35cb659043d6669da7bed73abf2f036040079fe6cb0652"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end