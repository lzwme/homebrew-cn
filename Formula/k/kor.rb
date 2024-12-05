class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.6.tar.gz"
  sha256 "a655d04eadde49c23fa8171248423304adb6db1da695df19b28863b90cae8e3a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa73e4cf19f405f9eac5c8e6cb5df71ab086229d64c03ebd14f4c867dbceff55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa73e4cf19f405f9eac5c8e6cb5df71ab086229d64c03ebd14f4c867dbceff55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa73e4cf19f405f9eac5c8e6cb5df71ab086229d64c03ebd14f4c867dbceff55"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87fc150d8dd9435105d43dba020e7b6fac3d1e0f4a9c36f06fcf329fe068b77"
    sha256 cellar: :any_skip_relocation, ventura:       "c87fc150d8dd9435105d43dba020e7b6fac3d1e0f4a9c36f06fcf329fe068b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5697519de01584e4de4363620ec58518893832d47b5259af0870f722cbb8c054"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comyonahdkorpkgutils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kor", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kor version")

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