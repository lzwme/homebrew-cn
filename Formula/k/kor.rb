class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "d1e88c0cfa4bac9f335b74c4168fd3663ac90dd121d55df5143bbedbcc85563d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e96528a996179f31666f15cf4d7aec0bc7203be37a753f6d858bb72a3b82427d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a497a11b415d4219eaa3b59e019c83bf6aa7c9cea2c14ea2a2d11bbe78cc98f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5abfc4e50e7607129a03065da5ab791f36082336650807caf16a2d87686ecee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dedd826910e0686899eddb89eafb5444cdcafdf641f94630f3d05ddaaf031ec0"
    sha256 cellar: :any_skip_relocation, ventura:        "0bfd5c424f31bd6f97f1cc015cc25480dcb5de30754682e09494a7ccb9cf94b8"
    sha256 cellar: :any_skip_relocation, monterey:       "68ba7d2a8a6981acee0bac9696ca9407d89d716f7981a66f92f65049f759a782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a50bebbab45e6fcabb5856af2de4160c83c450ddd4d5d447649f0a213bc7926"
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