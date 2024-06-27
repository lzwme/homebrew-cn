class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.2.tar.gz"
  sha256 "a514a536c7b379e91eda679b0942d66640450ca77862c61f1c3494f319927928"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d8de8069a19e27ac7e9659357f3f2c8654386c2204f772af2bf3a0ff2328f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8af3d50c07e3988bd490b38806d8df3dafe798b8496a379682f7736442678c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1422256941fca9144c4b70165ebc6be566454720c5c79f3f6522b93e0c6dde"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a7d242f63e942188eea76597aeef282dd28cebe13666e1b51838ca474c04fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "f586223b2acce021fbe34b6344002d28501001eb132192fed0fea47c63b86b38"
    sha256 cellar: :any_skip_relocation, monterey:       "98c13d7bf7a226759d3d22f60d7db265501136deb60ca1ef5a5c87528282bc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b56e030a29b5bbf8747994f1906d8115bee7653cc39a7db2fadc4fdd2fd943"
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