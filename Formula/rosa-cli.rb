class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "d4e8e303cd82aeaa871b1b349a4e2da636e8377d52b2235cf312b7b3b4775d94"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23a075a4b4dc07745847fb6fce7059f934d8729212c8ab4c846757f15ea29fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a075a4b4dc07745847fb6fce7059f934d8729212c8ab4c846757f15ea29fd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23a075a4b4dc07745847fb6fce7059f934d8729212c8ab4c846757f15ea29fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5936570400b05b8256bf2288cc9967be6a5f03e88f6d1dd4fb80123bd39382"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5936570400b05b8256bf2288cc9967be6a5f03e88f6d1dd4fb80123bd39382"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5936570400b05b8256bf2288cc9967be6a5f03e88f6d1dd4fb80123bd39382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8697720fd8572efd0e6476838d3f2f17e5105d73d44bf3207705772cb5c81f"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end