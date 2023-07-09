class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.2.0",
      revision: "2475f2f6a53c40b676f2179b071e12aa2513f9da"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1894a55a49fc33db2a3c6c134f8b12ac958be1352ac2f35d6bca3792edec672c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f51f300da3baef8dd46ead76e6b44214fec2813d006d068dc7145d70662fe51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3221d944a471a48368b7dea0c462e87abb6e06964e66acf10f191e233209b46e"
    sha256 cellar: :any_skip_relocation, ventura:        "0c09675e201d0a31c82f0f187e6b1d9fa2033b67c8ebad83dc38823569f4b768"
    sha256 cellar: :any_skip_relocation, monterey:       "2445ab54f89aba6a075768251f25b340bad7e0fa3a0b1b92c49620fbafcd8f7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d07823d952fb820e04f78dc76eb3d33cb9506b15461eb81d585ab8a6129e2596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48af40cce2f09c54d2c4c304108446c9c18f2e6669050bce34bd263ef901f2e"
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