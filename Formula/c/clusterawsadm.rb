class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https:cluster-api-aws.sigs.k8s.ioclusterawsadmclusterawsadm.html"
  url "https:github.comkubernetes-sigscluster-api-provider-aws.git",
      tag:      "v2.3.5",
      revision: "a9013c3003354cb5d3831250726c5ff8cddd196d"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1561f6ab6add3a7c0b834663099b9f8d8e8d57d7ce29dc94b2f5aec38d0e4ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9bec4545658e2fe0e0a34e0ee61b53785c8d39d7d56807d3e71d3785630ac48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b79b39f054f1682b71abdb12880d6ea13718ec1b0a42bb02eb7c25f50b65641d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e20804b8115f18f919c58170f8180ee1f75db7c964d2b9c49951342528f72576"
    sha256 cellar: :any_skip_relocation, ventura:        "d44884b0d4b7c62ade79d201f325c66fea58e5bdf8d25658fb3226adf4f848e4"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3a648dcb81f24ef5754d7900092d21a105a4e065d3beca65e6177c403f7d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a786d01d8f0db3c86016d7a15990bb19d4fd8ca4d3fb4762c4e05996dde4695c"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterawsadm"
    bin.install Dir["bin*"]

    generate_completions_from_executable(bin"clusterawsadm", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=homebrew.config #{bin}clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}clusterawsadm version")
  end
end