class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "6704582dac7b10f239e8478291a2e54f3e6d478fdd47d7d97e8baac9dfb5d438"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "558fc0e2d07d49dea0bd6b5c7dbbd08d2cd6d6c6d00fbe3e76919341a11eaa56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c9702c86538b91dd994c1bd3cd50b8402c995fbe66ff1d4410fd304fc23655b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b5112b348ccdaab0c5ab5ac29cccac9b7a8d330f4ed0a8e99aafad50ad89970"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0d7a76d90c52e7fb9167a255f573e36af7601c9b86eab19d765f470874a39ac"
    sha256 cellar: :any,                 x86_64_linux:      "a60b46f118aef19dacd9b8b97e3d88a5ffb9bb5de72b2f4ea655e97fd8421b2c"
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