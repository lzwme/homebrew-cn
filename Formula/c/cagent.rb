class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "230f63c36220275b05b70c620a6016c93d7fa3031117faae11125e23a3002e37"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "053e930922afae4b42bf69169245cabab8c05ad98eaa12c87eebba97313b8e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb370a41376ca932fb2689497cc5419a6f019452f87dbde323f2f9ab2f45ecdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbec7efbc263edafb7558197c913c6e4c7ff0d89a820333c042d3b41ebc248fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f875a7e7c8f8cf1432aae5af7d79fcf265a575b675baad055e1b52ebe0c5c14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c08851db1bd0f31bbaef3cfb6a1a314d25e7f21360352f2b4393d4f369a748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09552969445f2bb98661886a44aaba15e203d9834ee3d09282662e3495881e4f"
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