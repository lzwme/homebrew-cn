class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "bbbbec38619171c4138cb716b43115e3f2d447b95a89a54dae4c1a7232283568"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd7185ab3249a2291b6451dffe407c6b2163215220f6747041965f5ce6553fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c207bc3071b9e4bd1770036b5eb656bed2f6dbef6f6aa787f4d6092c9b3416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e095a6604a12271128f439d81d49e793782907fb08742fb6da881567cfb0902"
    sha256 cellar: :any_skip_relocation, sonoma:        "71fc2c1da8bc15f32a226ab0d2421aa13639e22b15b921bf9d58bbfa4a0500b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04be5919df2b0f402acaf303c2cb23d86f3689ed2b777daa830f19b449f2a247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89ed929a96ccccd4d4813bdbcfa667b7ce1f5239661c46d25fc7ac6de68966a"
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

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end