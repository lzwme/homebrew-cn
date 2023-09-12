class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "fcc26b3d7f0ed2dc4433914e7d3ff7debf9a4ccea9d1cb494edb8cbdc3098b48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e19170eb0b41aaf09eab928a084b848f83af1ab5c81b9a2e0e3dc36a4f0948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ded36125c8531d701587089f063be2302c4b36de9fe19ce4db9f76d436eee67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8727424e5efbd9e0f512a6a5f84e2fe7445b6c8315903dc59239dcfb658d1721"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb08134226a981265e85bc688ef96eb63bb364a73e677cb285ce68df2f2f2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "224ac4a07f89d268094968b9e935179a434ae48b5dea9620a3d55ce44e68fdcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0a1f2dde6f4701b7089aa61e06a5729a273497a92f59c1c9e8f6eecba16f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90451b590b21c9d9f68bb894d88ede7551a35bbdd0c50bda56bc1f134a1f6406"
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