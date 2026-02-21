class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "b6183cf3e8a83a4ec5117a1e00c8079b45ace677e79742f02faf41535a3e6426"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40aea7951378c81d6954874b6318aabd3411b0f278301942a5252e85acbcdf34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d68f161848511a80b1c2f9de846638357fe8457f36ee9f69120f99d5e04f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab23ee3214f39473e81ef912bef3295d0f54c54604ee3bf19a7925f2ecbac4ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c2cadeae7c84848f8cca1a1557650138c110693de4269eb3d5a06ccd70681c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63ae804145b0c83670718361457c50f9108d687c0bd15a84adbe2f10f7f9e1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622b3fc9cb2617dfbcf38defc7ace0c6cdb561ee60021dda5d15d58793ca4925"
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