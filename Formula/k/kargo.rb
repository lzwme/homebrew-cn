class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "73e715e87610b138485887df100e478dad4cc2a3e8e5f74a23ac979cbcbfc264"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "113a8cb686f21502af3986b67adde43b6f462f032cda91470602da93fda133b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "761e2e3db8b8c810b2f99c9fc1b17e196a54c22ffcbd95f89ca5d65346edb0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70e2b663af2f0da19d2ba1ad8626f42080fc06b0b77dd5b606c482eb3393663"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8224e14b7a8cff1e63218194cb25e8d4d72ba249f7474b87f3a35bc4384fe68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fc9eec4d7a0247a51957755f408d81d5887add91076469f7e2ac96c039d7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a025cb91c3a448835cad6dfce85aa0d44731d38d060f9f50b3dff04cfa603ca"
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