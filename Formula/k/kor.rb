class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "645f6076129fb40eb05baff8a6dcbecf29a5b09e9910779a5fabb0d11d9e6151"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7cc80b79ebe0c1f9b08480cf01ba3ed9f48a7fe61bbf3817df5753561ab183f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a988cbf413ccb66ecd8e76f5dc093b4c6a91fba28523f06d4233a805d862dac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f453056986239499edefdabb7d13caffd182ebe98fc6cc3703a70bb91bb2df5c"
    sha256 cellar: :any_skip_relocation, ventura:        "ec46c00091b62a59e4b9628b247b76c1cee13921639b16f92b8739ea6052febf"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e18e46c818868272345fcd280f82e7a6e0699daacd1099452cc97b07fec6d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff66c6d7c21a6935bccf74b744df0b33b3851af38cea9e23be9a736b5ed65efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a7db0994baa4c77a1c67fa0ec642df3726b3847bfaa3b491cacb3b9ca3a718"
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