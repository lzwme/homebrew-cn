class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f16cb85427401d617bf20eefd21349fb97de4a02873752ec2638a56ac3cb52c2"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ac10f54ddb793abb9d1ce9a3b574a6c68000fd272a104f816b70333787ea28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec701f486edf32f939b8465e7187195ee57e37b82ce762318c28cc2ac9298807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2527ecd92c152dfb5d0d87fdac047ecb8f47f7d63a55eff35b50c3f9d36d70a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "704b58fa7695b1291d3ec55b25f14d7bd233c34f0e76a56f13d7e2b5d2156006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d52d1dcc2f53e1548623e652ba31ffc68ffe19079bd220b1f643dae362159055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee31b84be062f1726f0ea8a0a04926d0d9e2b463845a3119cb11acefe859553c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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