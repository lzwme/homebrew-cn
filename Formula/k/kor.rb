class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.4.1.tar.gz"
  sha256 "1e3ab664840b4aa63cd5662ba026bb77b47898a48c1dadadf8a12514d8e3d062"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f027141f212e89523c916ec78ac4e20a46221d69dfbf1388add6c8dc287898b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73217373b61738a831569da5905b3175a0ca28bdd796a4c94b831c0891647a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395ea0f66f7204ca06861986392359c79167307ee34b6abbccc2414421c4026f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d75a3d904097ef83a21013a0745f0546a102c7a730184cd6361ef5e2834b4f8"
    sha256 cellar: :any_skip_relocation, ventura:        "b649cc31ee4de7a787d7fc580380ae0e5965b53441fb48b3eabc6ba4735aa030"
    sha256 cellar: :any_skip_relocation, monterey:       "7419183a3702344b7ce86154af17760f6a3605d32741745a0d0482acb2167294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b3b9dfc97cbada527e345e78a4512529374ff22cb10637775fb3392dfc5ac4"
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