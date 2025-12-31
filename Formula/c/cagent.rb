class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "767d96636ecfb81e4c0f10a38941247265afd1006e5e73315ff1f04e53b50d43"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd2cf6f51bccc35beffb5a3248c8d3694b24bcead4a32948e42f22998507103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958ce2903f20fc04b5ee60a24896af93e9d0debd332fa2e5e0d40105072d18b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed01e2fe1afa35604ed40ca55360a88f750ca51551f7b8fe89d742f8da3671b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2926af8de0cf365e969f3fc8e8f98bbc595b167148a44bbcb7687890cf02399f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea9ebffd75bce59c6ee302287f60be0484a0cb37b3db283f7c52e8fe192fcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc792ff2449ab539c067c420d3973618cfb9a4b7b945d23b66056377ec6826d9"
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