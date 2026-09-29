class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghfast.top/https://github.com/tensorchord/envd/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "a356b852f6a3c808666cd9e1afcebcc183c59f1b9f755291005cead411dc53d1"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3733a4f1712a59aa1f08d018166652de0ff011d9119618c9cff18aad702d1ea6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b533ab98aff260a6de5543c207b370086b6477778e707bc43d32be597518fedc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfbcdc6ef8d45116edf3a7cb67fba764120686ce8b75b64834d6f18c8a20be54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dc52ae5705ad935bec62bc5b8e38b084840db9e3e6ed91b790f716c2810ef2f7"
    sha256 cellar: :any,                 x86_64_linux:      "cceb56159bb58680b12d99ffa98386cfff61a9498f7101d4b95eaa3a7d54df07"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = "failed to list containers: failed to connect to the docker API"
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end