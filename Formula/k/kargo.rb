class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "86a63c67bd8ee4e949e8f5a1a6974ed305d7543e0ba6f53c57f76fc87cffbeb1"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1d90821777fe8a06b2da13682f4e6675e8ff06d2ccae613768c26875d6f38c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1b35d76014144ca75467e43e13a18b1ea9aa5cd86031ced564753a789852065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12688081f55934ac77799c924dbbef98361cc6467d340eb702ab5231f8f5b074"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9559755e78a993ec8026c0245bd5b27822617cdec3f7e424366d41ede085a95b"
    sha256 cellar: :any,                 x86_64_linux:      "b39ae55242876a4ca8443898dd48c0313c8a2dd81c58f42232887dd52df2bd3c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end