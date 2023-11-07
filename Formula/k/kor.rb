class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "53db48456803412f2a1c9f001c7f9979a798f5dcb412afadbec57b7350935d1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71e6250779b0e3c3d6df2e6f0dda66cb4db4a812107d9700393906d248c74b13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c6d97869bbbfca5cdcf0268898480bdd9218dbca7ad48723b9bf2ad8509970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55313c41815ce37cb5bfec95ebbfce94b6651fbc804cc5a1fa84866fa9229e6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6879ab8fa5a3e71577f435fe5dc371f438eb561eeee04588d7571a1d83af6067"
    sha256 cellar: :any_skip_relocation, ventura:        "98a1a530d9b3d8d409e8d93cace807b15d7a877846a3ec4a42aa3ee26654e648"
    sha256 cellar: :any_skip_relocation, monterey:       "62fab4a2bae81958c02ea53d930042cf6f8e33f2de0196d1b22254c909bea1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d45fcba35701f44889e14e910a671aa7545a1c1bdadbd68a5e8f07fcd652c1"
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