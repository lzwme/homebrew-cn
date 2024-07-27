class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.3.tar.gz"
  sha256 "0af222bef1bb897fde722b3c26752968ef569ba842878ff7aeca83583d367b96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b11c988c7e48493806588ec97b1b4d7a88f8918bbd923c6eac728cb4e5242eb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aea9f73688d775bcf8a0253bae3702938f7479aa260de16c1c076f9fabd5f5c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030d52b8f900834aa24dc3f439b1a0afe740566e56412941c971fe042929eae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "601bc7b636633d34d89490f56c5d5894b7eb756424df071c1c80b6a5ab337399"
    sha256 cellar: :any_skip_relocation, ventura:        "e89056ca80d0d1619b50c974dd14a319e711c0453c0283dc183f83d36e68038c"
    sha256 cellar: :any_skip_relocation, monterey:       "c33b96df873f7819fbf7bca0c8d70167077a33a9dbb3c67719badc29c380174a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f847b7130dfb25350668c3302cf645a557bfd281d7f9bba394c0feb08d6ad2d"
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