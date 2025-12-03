class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "409aa3e63a2f4cade6f226b87163389c30e0931160a2db27aa9ad069f2a1efab"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf24f0f2c7e1b96df4b56bedbd60d298937168176d0a9fee834fab5817bbcdc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9441eec081c9d54187aee6c67638234e50376f3c5ed1d3070c8e3c68b7f8eaea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634f8f1ebeede3fd8060c5d0bffe3e5157cb1ad6a238893e14f28b8289158ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c717b7943baaae4fef5c07ff05d1443873838746f87bce62532bfd39128ea530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "846576f23f023c8eafdef24a1728a320c29311c89a61222703d80cdc2e489280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01775bc16d3637b50b22ed449832835aedd94a500d7d360274cdc6e08371c28"
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