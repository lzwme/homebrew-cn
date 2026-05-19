class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "6ac0041977fd226616cddaa2f47c6e7c168e6a3fba61e78333c0163bc98cd649"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa6467a6d6a0bc97cfe1dc02e93c604b6a544fdf02fc09b52b92e249bc629a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8e42f9985c6433e5a8e367b85d84122ab2dd34babaa1d40664c09af68ef752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be5eff08e1f635c3fdc1393c2e9820aa3235db60908f33deef147d2d389eb76"
    sha256 cellar: :any_skip_relocation, sonoma:        "69eb51a94c58b8605614c893f50b71a21a507826df167242c5610f286b8d784f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd2c6b74b4a7e115505a3c2da6e0e5fa98356f6d99388c1a4c14516a206edd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57454a0ee62b78ed3fd8183cef7bbb44ce5b4745799ee9eb1e58e8de6744e006"
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