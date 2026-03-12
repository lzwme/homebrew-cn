class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "6dd94f728480de7fadc296e3dd79d5bc2c06d1abdaf6dedb5213b7786d1b7aef"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92eae729af74d15dcaa325a91eb0402482cf8fbc7a0184466289f61129c2cd29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe87e95dd7461a3a44ab2ef65249dc5e979c133532b3839ebe984a9b9d4aada2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f05a0af1cd3922dba184d60096a1c03b93e045867327a6ad7428e05cf3cace"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6c7737747100b0ae704f4b1ac5fd84ed6380bd983ebe26cfc6083fa40fceb3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce2770fa7d24ca6413935f77ede85856effecfe1f1cf696b908fb03027ec1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604a978c3c3d2ad3d156aded3640c4d08997a96c89c8916dd2ee39f360c32cc8"
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