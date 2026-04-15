class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "0bceb1500cab0d34d639777e7d044e38c5bd575206fd2c187889a796285877f3"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93555c2b33ac59c77c9fd5f7ae17f71e90a9a766083ce7972e5b4031374ea004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95473eed699d9a168ab89a7e2c8be7da1eb4e2b9c76e8bc571495f572cf3f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff3e4be1d704e982bbfa509c3fe55054fe99dab1403b6830bb870cbf648dfbba"
    sha256 cellar: :any_skip_relocation, sonoma:        "172cfde8c9cdb530ed0412fb1abf1a02138ce40999278cdcf204e0957feef6d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3889341643f5c94b40c80ccd555134170f0bf6456dfd0f9633c8c7079a10bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d5e892782f2055ffde26a5a2e9198c853d12f783e07fec527f268353d1d0bd"
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