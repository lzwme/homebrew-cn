class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.5.tar.gz"
  sha256 "053b7ed1ac76c8dee9a43d06d8ea4252ad9f4796a63f9cf3e27f887eee5401e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3cee3cce2ac99b591a381ce3e2c93286110881c866acc07f303b733dfd6125c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3cee3cce2ac99b591a381ce3e2c93286110881c866acc07f303b733dfd6125c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3cee3cce2ac99b591a381ce3e2c93286110881c866acc07f303b733dfd6125c"
    sha256 cellar: :any_skip_relocation, sonoma:         "49408898059b677e032a69f4609254e6e67bdc23e0c2f87be85799afb210eb5e"
    sha256 cellar: :any_skip_relocation, ventura:        "49408898059b677e032a69f4609254e6e67bdc23e0c2f87be85799afb210eb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "49408898059b677e032a69f4609254e6e67bdc23e0c2f87be85799afb210eb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e634e7499ba0c9628a01bba64de5bbdbd411d2e91b31de05f35b8e7bce36db3c"
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