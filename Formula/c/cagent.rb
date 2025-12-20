class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "dd763609c7d8f9707d91e451d33e3d9917f99bad51e00aa267e1e97c0abdd3ef"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318f9c5b66acf154c49ffa0c58ff52870258a374028d6e6f7ee739780e3f0027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c315412365c730954764dd1e724c2894b6a234a600e1896fcf5d6e90845788e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9984085c69e9117f40f1a7f30b633a4aea43a8d3c11fbc8d45c6c57c409aef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f28914f7803bc8d37ec88dd1024eb11c13929edaf507628bacd922fb48dc97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88fe0882fae150467ee8b8a8c31d6267bb6e307fbdfeeedb23af8b36d0fe04d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b954a47b922c1009e312b15bd0c81fd7ef1f42e41973798729955bcbfed6c5d"
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