class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "a58cef47947b7bc9cb43b4cecb5b0753329608b2be99035b82d551f98a94dcb4"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5992044a9b9b226fd7f45ccd741c849d07ffdfe504fd476c4dd4f53eaba3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4157a2bf92a291719812a643caa3aa65bed360775d88f4e659ea49f684201cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919e45a41cd32d1dc111e65719ae181fd168de4b3c87cc1e6e1f80ee9baf9e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afe39aef14ac752467a363e588aade3c811e7b415fd1310ec25604d65c6e92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "addccfbfa452a88e6eb6fb175de5ef6f2fa377bdc9507161309cde95299426f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b17ddfd7ed4a50a42b1b18685dac50dd7c14db6d3e3833d72f9ca4e4de277b"
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

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end