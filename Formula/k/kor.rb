class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.1.tar.gz"
  sha256 "52c9930ed136339f359143a6ceac97333d2bbd7e0ecc2d65067a6edf87eeb6f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92447c3ecc3160c8da903ecb90773c76ec403efd42599bcd1b8e0c732ec6643d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27a587765589f70991e84d9d7d1e9741ac910af803e28e1b58fa49630a2123b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28857ce428d85a5d55657a56fca901aeaa5fc9bbfde25730ce7cec693d542ed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2138217079e54e1661bb83513653626b8e1b2cd61eb32c94c715b28d5782b361"
    sha256 cellar: :any_skip_relocation, ventura:        "a7fcbb5a4739ff2d92b67e2f913badcf3560d537d0534dbccad7bf5f7ef4b6cd"
    sha256 cellar: :any_skip_relocation, monterey:       "295198f6c1865562ff78838ca17cfca76101a3d85c55ab3f7f598737cf8a7096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6ce61d303462d31e93ed792ad586d065428e172b37a1901d5fb15bf835ffabb"
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