class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https://cluster-api-aws.sigs.k8s.io/clusterawsadm/clusterawsadm.html"
  url "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git",
      tag:      "v2.3.0",
      revision: "2562a8bc41a9b76a25dd6b4f6ba9252a033f5ba1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c12128b0cce834a34e11e996033e3b47da559ad38a871fbe927464e3e6b34c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f3f2bdf11fb1ad1740648485c7a6f4b5b4b171bcc7924fb1a69f3cd60d19d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a5746074a5d9088aadaa6d765ba0d4048d2453733971178f7b20f9ba725e6e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a6efc550247c1a5d9fcdda44a8fb674cc4e28729fc32b63312a3b3b94c956ce"
    sha256 cellar: :any_skip_relocation, ventura:        "98726ccc527e8123717432801e5d1924af0c3bac9764b9db5cad4d6f40a9dccd"
    sha256 cellar: :any_skip_relocation, monterey:       "900c104237b1e662779366f78b58a3267d04707cb7b501894f13a2171af96af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab721d5f9cee05a2d6ff04767421b7a5ce2cd0b71cc6703809b1681d025628e4"
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