class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "c5af6669bab08d8be09235f613c770a6cb4c8fb56210aa281519677540cb58f4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b21ae7779c4f92e88d3dbff7a53ebb2863e07b2bbc2ccf65215507eb02599daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c61b6ee05047f74bd2732543af9474ee78aaaffa2de7faf9fdcc5e59fbaf186d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52629a6ee55548b827fcbf1d6937858173f5857b2ce0e5c9e3ef3909bb46ce6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46dbe6dee94daa16024ac7836db6607b051cf70cf5c1559a4c73d2cd869fac27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724bd400021cd04dff2c14776571b8e1163ee5ee937b56ebf3114d34bfeaac7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7911b0c599eb0807faf0e32454922b313e45f76bb855ee32ae6fdbf23b337436"
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