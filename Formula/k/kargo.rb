class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "2b52386ac932859e45da4b2a4d3ea796e6071a72419d3050504026d3b8d0fc01"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58369cc5197c279ea809c09ec84916bd980890514accca0eb59eadb123c61f4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c93e62221545bbb04cdc29b1acd024640c93c721ffa9d90032f3377e3e88848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5375a986e86bec9a3495146e74296a09daa893ed4738d122db806aabcfeb688d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a41f660b2f9c1e4ad31569f51c22549776df06e6e9ae23d2084714b65cc3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564000442611bb0e8d8018467f597014513961d26f1b6e1e3ede52be60d600ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92511cdd9a49f0dcc589da31878c3519a011f568459d8c4f0c2a20ca26704a9"
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