class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.1.2",
      revision: "4c6b62ff6f8094d5ab0b0b842d788e26fd84bc8a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd9297d1ceeb7ef4b56ffcf399ce966402af9e47c5c8254d5e219942aa41e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "002f07c1607e36136b8bcdd302d7bb2b7ea7e0f0b21f5f07aaf089f94750da5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b53fb6f48f25db13dc8afc48c51d2685d764859ae626340a0082b78e69fc687"
    sha256 cellar: :any_skip_relocation, ventura:        "69185ac97d00c8a12fa395397c0d6f430b938611079d342486c83509b3d7a6cc"
    sha256 cellar: :any_skip_relocation, monterey:       "0081ea3720c01bb26d28f8d455a4ffbb7e4be5890712b1757ed647a650c26650"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44f6e5c4a4a1cbcac28c04ec26f647c7b40e9a5abc1f35ddf032e84da10d554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70818f9d5ea48cd4cb534687c9a91768185e744e1f2c5bec34571bfcbe1d418a"
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