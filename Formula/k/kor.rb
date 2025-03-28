class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.6.0.tar.gz"
  sha256 "55b7a31d731776e539970ddc789de2595756215d178c6decf1b78dc9c876fc0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f704ad39dcecfda47d2d8c9ddcc329e93bfe8d8f620a94b9157137e4842bd697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b2d87bfe79753a5a0926c35b883f1880ec0c3f3f1482cf44e0096bdeba38a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc35f345bb6ba8876a8878336eec29ddd64059b9f95f25f94d5f2badeb8b3425"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d04500212d69a041e874e3c69d28ce5fa392a07ec20f59657e0c36c6b23086f"
    sha256 cellar: :any_skip_relocation, ventura:       "d0e59383539e1f0f39e3b1c263e0f44ad7cb2ef8a606d76ef4d0c85e30e3e257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "134dd52e416fff9086650e6a8f67797900fdd8272446c37e79579073cac0d7b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comyonahdkorpkgutils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kor", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kor version")

    (testpath"mock-kubeconfig").write <<~YAML
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
    YAML

    out = shell_output("#{bin}kor all -k #{testpath}mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https:mock-server:6443apiv1namespaces\"", out
  end
end