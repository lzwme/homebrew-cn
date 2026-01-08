class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.18.8.tar.gz"
  sha256 "ccac1ccd56315afaa776aacf7d06af24dcf1409f7319013b600b076b28d26625"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a4806894b52b93931b627166f4117d72f3e2c82b4f9c8ba578b45a7f7f8789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a808cd693d2f53e33e3800bc1b9d7717b2b156296edb5b9ab5a407959dd8bdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8489cbfe3d80d631db465e25720734a786031dd1b7f278018eeb21f22080d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99e04620ac9b07eed2245819faa5f7711c843d83f1119060bf0dbf6e4eaaa08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e6d40155ff4331c19817474c3c03789c56e53039e7a002bdce4a1d840f793d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14378abf952ec5fe486201fe039ee5cfd75cd6956ef67d5532578fb262de6d8"
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