class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "da777cd7d5a25e1f5985c7f6ab9661a3ac42525cdf768f7571106fc7f4b1e571"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78af6ff6404cdf65f06907a7eb5c3d7215b9f5fa98b9d8b25b566c22462056e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1afc583e6d3e45546b81dedb2797baa20868a70790e83c6c27a510fcfd73a537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30809cc10e7c13234b09e359b6a3bc86c1e7ec16653c25b09bac95705d12809e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a77557d6c24d2fd3c3260522e9a98082442dc2779517cdf3e14cb7bcd8b7f32d"
    sha256 cellar: :any_skip_relocation, ventura:        "c05a921c86a2b19d744dccd0f74f433e06a2f8a24b072284fa5e0135c3a3c503"
    sha256 cellar: :any_skip_relocation, monterey:       "d852af8be78c28ce7515324cc432a2794f26d5754dcae2ab1abe848b3b669e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28a544d106df25a537d97afa72a92195134ab3bdb58be00a2e467256706958e"
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