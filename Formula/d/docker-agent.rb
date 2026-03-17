class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "9c86c44fe64f2b406a115a1aaf26df8089ec660a869982a1fe42709c0fe380c2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab0b924abb2e2c6de43e5ae03211c82cf927ad1db35dfd3af352ed3529eb75a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849300ecab26e7ebe8a72ec37b367f7521e478df25248a71001873ea8821fbcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7648cd19eff6c2fc4c49ce75f4d33794fd17a011d047bca01b092f3e2b0a42"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7622486d29006e4af6a8431cf21461b7cb833ba9081bd5f397ccd16749fe0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ea2c19c8f1047c0a58a9cddff1bda2bc7e5584d8b826d136a6f7ed65f92d1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf48770657ba2a0ca98d36d13338764bf0bdae0062101ef4f171fd3e0c7146a"
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