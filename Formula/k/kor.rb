class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "078403454fe397f3ab894e2f226537c56b9ddc2db3c29ebb24ee90d511738735"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6574e026818adfb5f5132ae3e064f27667b1ec8b762a11e638172a61326194f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e057304cebafd06dc3380b4543747deea75ed2e32d708f91eb910bd4cf1ddd3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db7b5f0d646b4c7855628a5d3d40b28b8c92317764334680c016f20d2d0d52d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2eedce17ba3193db87d22a2be952f412a27740804f4c22b7bb8189dd5a07566"
    sha256 cellar: :any_skip_relocation, ventura:        "729aa4963d0b8b8a0ce1a87f55a17918a3c39429408235b35fea0dcdc9e1c602"
    sha256 cellar: :any_skip_relocation, monterey:       "c672435540542edd9c96624fb641e5ffe0f37d133ceedbc105cb1ecf732daea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b6ca46b354f90b327c7ca7f6641c8f3f73ff520fc61603531a0021819477e62"
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