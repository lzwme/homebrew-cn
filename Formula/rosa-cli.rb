class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.18.tar.gz"
  sha256 "97e02fa90371b327055c7e450f4041398acf2205f78071c9e0398798bd8dc403"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5074b5beba664680c4796020b5231e2e7260a18917805fbd0a44976a55d482c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5074b5beba664680c4796020b5231e2e7260a18917805fbd0a44976a55d482c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5074b5beba664680c4796020b5231e2e7260a18917805fbd0a44976a55d482c2"
    sha256 cellar: :any_skip_relocation, ventura:        "45037ce9b157797e535907bd6f3f7c500dff30589a44e0f9ad66953d24c702f6"
    sha256 cellar: :any_skip_relocation, monterey:       "45037ce9b157797e535907bd6f3f7c500dff30589a44e0f9ad66953d24c702f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "45037ce9b157797e535907bd6f3f7c500dff30589a44e0f9ad66953d24c702f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad5507b281124b9708e43f11951b9b48c0245b4c8ca90a3254fdb5eb23b74cee"
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