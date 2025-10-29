class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "f6f396ad1f67c4e5ead658a243201333550a04c80a846e3ea59c20ebabc75272"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "631bbd360a8dd19f47689c591ebe70d5f3aa5e4df7dc009858ec833c219fc751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5bcaa99ae934eca20da112da68e210cdb7b3d8ab16866a09f8532f892dda279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5694a59757d37a94013daa2c0997a678539000faa3eae0890dd9057abf0c78c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94880e17c07de0aa3f737b1145f0e2770ac1ba291e6427c18e13bebdc3d36307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79758e9e9711f384774c24ae227d307bcf3ab144631946cfe41543bb379aeec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a16c59a9f2a4e2bcc831c41c8c44654899815b69551f1dc07e422db12eab2cd"
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