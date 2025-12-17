class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "520b64cec9bdb869a43692dc874bb847c6cb4155c6d04193060f02d2fcd8d382"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9faf608847993ebe937114066d47c46e647e0bdfc9dcd5ecb8f6ac5e7ddfb75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12511004f1d1dbb738cd048b0f5c7987b02519789a5f578c2df59f775f08c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e23da51fd1d8dde15a37cb776fad77e532150ef6464d652bc6aa5b3a134f7bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "916345fde7f81621d2aa57936dd0e6db2bd852ae810347ecb3941b9b4f0fe3fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8630bd24b1b0b7bea79db7c1c9f7b3fbfac361a00bd9c62ce30a9132ff7b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638f93346b650f9093a1ea0e5032ce80332c916b864bedb78fc8182574e4e34e"
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