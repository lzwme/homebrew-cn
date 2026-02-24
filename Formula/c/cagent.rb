class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.23.6.tar.gz"
  sha256 "ef96e31c01f964e339f8b0dc035bf38b2c2e00d9f86d9e030b9e2716fccf1f09"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24bdef17cc6fbe4cafdc3fde8324630697744ed42c4da0964e8882356cc63e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9822826b1bdc657bc7b5963b5d3c299e29d310d584b2ac76ce500633dc86e75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4742563498d7044e7fb7103eeca84df7debd369c49ae20e0dae3d35a1cda0ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c68b32861b376373c88b08f52e304aa8a7d8d5bff9e1d09afc6e4134969c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a4e2d402fa34f9c0db2f85d961ec64b8c825fa397f8d9bfb8d2adeac21ce9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa3c2a10eb36e39b951162ca159ab76e36a5905d46e2833fe0a00bfd42e746e"
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

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end