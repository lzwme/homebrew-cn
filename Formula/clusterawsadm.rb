class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.1.1",
      revision: "b22f9d9bc0b5f904102e562ba033566393a11bd9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a5865776828b46b415a87491e5881dc3de52c41982f65ec2528c9b2abb04401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88cd6e7ec379f25d1085566df5d07e9c1ba5366e9c676a429fb2392b1f91b305"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8f5357e2e589b40b1d3975f215c10598e7fdbc7fc1664d9fa57ac013d57608c"
    sha256 cellar: :any_skip_relocation, ventura:        "2601a80008284be069cc165af4a6cbe542592cb51f311d3bb02aa45e1ac9e941"
    sha256 cellar: :any_skip_relocation, monterey:       "2f75d7462d1ad1b91574cbfe5ea47efa346d3d605952222c541a0cdcaeeb6b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "751e97f2565e3bf475541c8a4a72eb65761baa6867b58c9f3277d827eee18ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2d073f0551341bc08fbee2e3f223d7be2690a659bf2340dc114c6a91222184"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterawsadm"
    bin.install Dir["bin/*"]

    generate_completions_from_executable(bin/"clusterawsadm", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config #{bin}/clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}/clusterawsadm version")
  end
end