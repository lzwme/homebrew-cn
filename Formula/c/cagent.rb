class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.11.tar.gz"
  sha256 "c11f8e4d7f6bf914ca081de71ff97b84bda0c0a9fc70c45e37b999b5243cb5c4"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b0e14238ddfae1c2315b8d261dd8f666771467fd4a8709dda3b893120394dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b0e14238ddfae1c2315b8d261dd8f666771467fd4a8709dda3b893120394dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b0e14238ddfae1c2315b8d261dd8f666771467fd4a8709dda3b893120394dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7377756d087846c99383d77bebd433811ef282216a077e7b2d08351c576f57db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4abc6dd4c044d4010b3b330e22a6b2f1354c658e94dc72f72d5a90bc58b07778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3cef0b12bcdd97e29939e4dbc370edee35eac426c25368292a949a47de8ea96"
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