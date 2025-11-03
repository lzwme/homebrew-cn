class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "20d9ebf3ea44bfad18e943865e1a9c69577ca87454479e323ea5846d5e1023b9"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "631dcb7db542d8dc6ae969aaa6225e81abdc0a234c1d8eb2ebd8032971f4ab60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631dcb7db542d8dc6ae969aaa6225e81abdc0a234c1d8eb2ebd8032971f4ab60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631dcb7db542d8dc6ae969aaa6225e81abdc0a234c1d8eb2ebd8032971f4ab60"
    sha256 cellar: :any_skip_relocation, sonoma:        "278dc74b2125435deb00f458960651823918b77794caef32359e530332fce68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e757b87bc7ee2285eaefc5d3643195c5d7763341674da567566262443d34cc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3469328f56c68f834af23b72704d9bde95d5b2e0ad83606c5d85cc4b64ef9a1e"
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