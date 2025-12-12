class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "78f10e24e0aa0de1bd58c983425585572827e18d8245df9520d900f31c8ae8c3"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e23bca25d0b84b6bce9331ed9e903801dc30a68e7e9fdbd08f8880bfb612d6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1cdd76f26196ee793cc9d4126be40566f223e1bc8f74481d11a1d81f440b30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab317e62de76dc6380f1b8ace3214bf180b7e9fd3d58dd683a7e0cc3d6270b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee109b4875b0aadab7ca8ab2e471887f9c6fdcf00b8ae1a68dbe9c2c43351045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "308ade6a46300fe18e358fabd3523c2b2d1f921ef31416a7773b18be9c6a727f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ba2c53b915563ffae76e74c59fb5b1a0c53578d30c612b8524cf18c082c689"
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