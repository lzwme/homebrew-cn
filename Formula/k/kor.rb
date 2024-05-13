class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.4.0.tar.gz"
  sha256 "dc4f57b5bb6ecaf7ff147ba9ead7d5c77e1895b7cb643b904aeab5518bdf3238"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "258e3e9116a75f73cbb9982b2b2a1244fac5c8833782a0b44fb834507ae1d5d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa420f23059b2c2bd3b59e6fb06cbca67ae65a287e7257214c64024911049779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314c8e9750020317677387062266862776aad0078292088310818a2a167bd035"
    sha256 cellar: :any_skip_relocation, sonoma:         "c53136964489484caaa404f0f143037c8a35715ac13b3228c85ea89a56cb8159"
    sha256 cellar: :any_skip_relocation, ventura:        "29bbc63ea98f73d9a878b9734d0656f5064bdba6b44b7fbd8673a487110305f4"
    sha256 cellar: :any_skip_relocation, monterey:       "dfe7a89826430ebcdbd355bd9ad39a0d8c335da77f59be8b9c7be67ad5553760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7b6c5b90a697abc0f95acd05c0aa9b08893e13cb7cb4f4ee2afa4b94ae41ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"mock-kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            server: https:mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUsermock-server:6443
          name: defaultmock-server:6443mockUser
      current-context: defaultmock-server:6443mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:adminmock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    EOS
    out = shell_output("#{bin}kor all -k #{testpath}mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https:mock-server:6443apiv1namespaces\"", out
  end
end