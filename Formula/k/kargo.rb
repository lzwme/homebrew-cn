class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "507cfdf65f55f17f3347eb8d02265eef9cfe843b3e36214bbcb5d4dde7010f49"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aee90f470eca6a2def8c1acc1ac1aedc3c333c58108ad3b0f37623b1a2593cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d271067371ec70502efe88360e46e6ffa7af2875d80c3557bd0bcd1d8104488e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb5f797149f6bb4e9650279c5dcddfd7a60d8765e9e0549a31caae7da67e04a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae960cbcf453728147cb5c53fd49c7693fae091ce387718f64ab47fa41796cc8"
    sha256 cellar: :any,                 x86_64_linux:  "e6fa798e5986076ce345bd1677c3dd5d133cacd67664a2d2ca4f4a284b0f28d7"
  end

  depends_on "go" => :build

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