class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghfast.top/https://github.com/openshift/rosa/archive/refs/tags/v1.2.59.tar.gz"
  sha256 "18dbf016193169ad8fe4fac70dcb896fc5ed0b4d14bfcb8039c913dcd4da153e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07bf7145a77864d5afb0f9d2d6fbd94451a963547774795abfc69e87e6b0d5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af75a986b3cfbfdcd4715adcfe74e3b5fb8d92e8988940a1f3a826ef29957a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "413ee87660879890a623a3872bfa19de9d128b1bac848610e029ee66b37e425d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1692cdfa851335e1715c8770b43b7a84079ca9e1b5b2d45a4af392c9009a0c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab9e8d358cb334c9a9122a6dbe6e4fc7f6d4a23e88a273a7795161635733956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695ca25a28c07948d025b93eb5ab720fbec58a0429d7456b01cc26cae75f7dcc"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end