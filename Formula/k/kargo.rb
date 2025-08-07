class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c67bbd3a707af4eca14daf8b2cafb1497453fe2a52d969644c27de3d6e494627"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac44acdd1fa2232ce4e85939a513fb5fb89c0aa42b4a5c8bd213dcc67691515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401856e58616d860a401d6c7e87f37081f347feb458926a836c8182f039b328c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e27597f6de00c666cab4b8d9fd8ac2ac676060150ee3415f81846b459bec7b26"
    sha256 cellar: :any_skip_relocation, sonoma:        "46f1c9efd2c2a5e46a675e67b1c41f77be6e3c7de48af0a46a1c0d2942ca6931"
    sha256 cellar: :any_skip_relocation, ventura:       "319035121e40c28eb95ed81365cdf1d32701498e7d15dd792fc542a6b526cf2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bb9713bc86b7ae331762bfbe33ef431a2810f198832f70810539818181ef722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efa94175ef9e9da988866c87d0793edf59ed2355bf9104760898675f3d7e94d"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end