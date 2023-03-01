class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://ghproxy.com/https://github.com/kubernetes/kops/archive/v1.25.3.tar.gz"
  sha256 "7ecd4eb7dc109d34fcd13930d0660342ec5945d0456a63ef4ace2955f556d450"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab459b3293cbcd8d6b0827d4b23af8449a3810b38d0bc0c4c821e66f7b3a9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ebbebc2f36d16b1b9987d57fd18d4134e0a697c737235799bf9f5eeb81a2430"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6c77aef751e0bf2972508f0b087b5817cd21307090072d5724e112d710e2b60"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa275955609bdaf8ddf700254b6c9742c24e375906eeedd2bd534e9cd864670"
    sha256 cellar: :any_skip_relocation, monterey:       "9745c086b5a923336a992c2acf92d0a1f8462a3462a55f31e1bfe6526ba6bbe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d42775fb0cf3d22ae072d933ade1efad35ec6fdc8b58d5fdde13f598af24933a"
    sha256 cellar: :any_skip_relocation, catalina:       "07096057856cfb9620419a150bede943dc961d9f53bf8f9e82cca6d4db797382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd9a621067522b14e18e3c5ad67209b897c56723176259d6a61a3f8dce38b0e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end