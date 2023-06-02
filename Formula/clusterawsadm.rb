class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.1.3",
      revision: "7f7af3e0a3fc2bac59ca3683f420dea54ffcae2d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e158437d0217e730e9b52ab1f97db72757f75dcd9a72e3ee92c4c675251f2e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee60a92eb695b1e34cd6f96569df9b270b22a2316ea9e42b0e8aea307ff76190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7415ea46462809afb25bc74a32201a0fccecc5200372c1afa221314f94e4b4cf"
    sha256 cellar: :any_skip_relocation, ventura:        "2b5f97adee66db660213a5c5d164e6176d1af68263b56d2fd5f1b126a012f2d2"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec55859b289ffc86d4625d2ad4afcacdbb49efd097f9fad51dc1a745491ef3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "010181bbaac933190cbdf94bfcfc33b0813962e24bea31419e83850118ed2d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58a156828c17661cf6bf98fe62f2fcaf9a61b237bb6b325cf53f325488e117c"
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