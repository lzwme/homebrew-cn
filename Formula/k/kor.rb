class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "1468115fd2bfcf97026781db0e2030be1fb91af5dbf009c59102063c11b54280"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "773afa5449e7efbcede59ef64f988d914c7498f1e88ad0277a95da7d567d4810"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da92c5afb9cab4a2817e26a3a5c64264e21e10a5489af502c8c50d0ba264ce3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "987f9254dad9e385cca375da28f7c6eeb0bbf2605795b7baed4c3f4e9b6f91c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b38cdab42de71cb1839b3f6eb4570fa7aa87dcee1bb9525f61ff9c0cfe16f300"
    sha256 cellar: :any_skip_relocation, ventura:        "a7c2c5dbc2765b6bbcf4d2c496dd7562f64f7bb03b84cef0d1714eae20020ce1"
    sha256 cellar: :any_skip_relocation, monterey:       "f188ab0080442b729d37e866dfdb3d38d17ed2273b11667965ae5aec2d70c2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee71becc8f346072a0003ac512753bf021ba7c83039d33f3fc31a940a61b4e3d"
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