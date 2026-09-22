class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghfast.top/https://github.com/openshift/rosa/archive/refs/tags/v1.2.65.tar.gz"
  sha256 "b28500c2fac3d279e759aaf53e82346d4485a6e2e2cbdadc3ec20e120d7a5495"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7702fe577df461ee19bd2498248c0cadc107f1cb8962a542ef361dfb4fd34caf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "320d206c4b76f254899c14f119c76bbd261befc41648db112b16b0e1bca7725e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b374ab634b349f504c89d0aa8099333f8c2b817bc088e92be2707f4687a2795"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4014a0fd6ea14a03c9a93a5e249b92034b50ac71cbbae6080d69d88793f010e6"
    sha256 cellar: :any,                 x86_64_linux:      "fb9db79e56c3fb0ede41e2c750d85a7e671f72fbdedbb06aef242d67f2bf3c17"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end