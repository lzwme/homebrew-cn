class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.9.0",
      revision: "dcfaef0f0308aab17f70feaa50b5f87a0b0bcaa7"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9b81c5adb4634e4beffb7eb25856a2954290581b33867c9af16242d0e0be91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11c5af68212d0c360711825c3c9b83574fc4721a31e837f0ec91ab52f0c1a41c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce6f88903c9ea028451f01b2f2e8eb6f7b30ec160ec5a5f35565d3c9a53029d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad194a868e7d69c609edfdb2c44655347f6ded26a7b9355303cc8d6bf52a761"
    sha256 cellar: :any_skip_relocation, ventura:       "c17283cbe7d70b6de3c2fca80e4d174822f36d1dca058e1fdbbec1062582e3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36f523f7cbb00c1b122a8899f74ef8b74828be12ce3b75b99739635e9188529"
  end

  depends_on "go" => :build

  def install
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