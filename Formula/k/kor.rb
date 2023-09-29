class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "cc8b5f93b53120e963ec2bfff18b1614a82909abc1a77a25072f28cbb9947627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "132a42ad19566e7773759121ab4440241d368d5ec16c2318d5595b267d43fe8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce561925bb9a0908f2a747d0b104a03a97bbac27b8815de822f608513d83aa0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e217fe88073da7ef08a8d43e8682c841fb97dab87540771ea23f5ee0dad4df37"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc072e934a31b5fb050e0aa32fa03f80001792cdeb111462219ec8b36f487e42"
    sha256 cellar: :any_skip_relocation, ventura:        "ea7f8a0e719d50a8695dcca7270456edf9c217fa585563652d72fe5cfb18f4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5f315f751d33b952b3af34ac86a4fbb40a9d0b9fc8f274e5ab97c77cb383328f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9968e9e2a2da382c61edf31f5d341f17a6969aaca4f049e89bb4572f8ebbade"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"mock-kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            server: https://mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUser/mock-server:6443
          name: default/mock-server:6443/mockUser
      current-context: default/mock-server:6443/mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:admin/mock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    EOS
    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end