class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "95fe7dbea9b5c2c282380f45543f963dd6177fbb408f1cd12533d5244bae42c2"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba40ecdfe4360b50070a7bd50d34a166047f797c309421c551bce563e48c2a3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ea9528328fb07f222372313259db3e176c60a1facde85ee1d85709a6e9ea73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4abe378e83d61dce873d59c993c1f10739499a07d779be9a958ece38871f023d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec89dacd5c24a68b6f877ab9a0c3b0babdc9f0a0cad7c76b0c7e2da13b56a56c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d2430b8407074028b64cf42dee6ae43359a2f48f695e677f57d189c2666edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d08469200a5dfc45daa3a8d730be96c62ae8930bc0611eada60aad5d3840050"
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