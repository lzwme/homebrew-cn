class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.3.3.tar.gz"
  sha256 "49fbc33f4a946c9f47ca67bd94900bc415c29f1e0ec03af894ef6fc8a532a52f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad98110cfe1882ab86f6e108e5de72329cace392458be38afa3530aa86ba97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9708b64ba6b263c999ea61fa03adc962b9b27978b29e73bf665b8faa5e89e9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08496c8d1cd084f42632ce35c2f3597e9f41a4b3a03c49653a66b8a6d49aab25"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd924f3de8675e366d9dba4a5ae1af8a250a515599aaa1f84bbadb90334f767f"
    sha256 cellar: :any_skip_relocation, ventura:        "dd22a95947c6f2ec71c1ff5f09f1b2479ba1c041962593d347e2dc72b62c14a0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b97c68532800bd78bd074eca8098ed0a0283fcd4f83c757ac36858b9db2d0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235b41928fd17c9533b753dc9410937ed41e0818ec2808672d221e8f827ac394"
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