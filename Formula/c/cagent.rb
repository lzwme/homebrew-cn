class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.13.tar.gz"
  sha256 "8728b4066a68f21a823a789e5dcc703ae98ebe78f380097c77ffb85208f52883"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2118b76b21b07202b33bfa8b81b01fa7b0d5245a1090135f9a7e6c6a9f89bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2118b76b21b07202b33bfa8b81b01fa7b0d5245a1090135f9a7e6c6a9f89bb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2118b76b21b07202b33bfa8b81b01fa7b0d5245a1090135f9a7e6c6a9f89bb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac366786d3cb1c9f303ef3da40d9a12f4d14d69944388a56a6cab929f675f81b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "006b2194f50f182bed35f93bc5b1432d7a250fdd3e67221393b2f8febf9e60f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e390e179678f35f0d1ff7324a2a1fc5f3979f9ed94e8e250ce5197fb3250b5e3"
  end

  depends_on "go" => :build

  def install
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