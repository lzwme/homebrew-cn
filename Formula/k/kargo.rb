class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "8116f4a9cec006ce5841e34e84510d339fd38577b12c770eba844b841c59b1ca"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe07e382f8a4b68d422422ba03fb45dabe1a9855d067fa30ccb3a202017815ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2298610a4467415d5ddeb0d82cc9684dc3887829e0fbee3c08bd1349b9e19ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "368999af7d42d2b319ac9a1a272b0689523747970d2201747171cb26bdfcf110"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "315851a65fe21512e7dc217d6acf29477e3f815d4e4a1814095578f6fef5fb86"
    sha256 cellar: :any,                 x86_64_linux:      "4ed5b936a624f5d62dc5efe6adcb8f5504ecf963796bd887fbc333c85b2977f6"
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