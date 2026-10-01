class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3404ee1d6d9b6c14ca293ac222263a2baaa59b6b2502a6824b27d44b4261ac09"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce7439a13f4628bbf6d001d27fa7a0b42922b2925e849866139bbde6dee0f4b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd266b7225f1e1f809363bcccdd6399123aa7147ce0a58c9eddacf576ada5193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77b6436e23a06936cdf32c70c4fe5c790d998a05acc0624e68520cc29e550ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd263b501984b692eca1b254fce84ad33dc653e3d220c8428f3460c4dcdb1eb8"
    sha256 cellar: :any,                 x86_64_linux:      "755787723b8b53a7160982f4f2fe7930b2548946adb6a290eb05aa17c4fd6bc6"
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