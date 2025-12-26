class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghfast.top/https://github.com/yonahd/kor/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "c635a981f05ba3f1c21395348e858f6e4354455ae019b023e84fe408a29c2294"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08457d9c20b4abfac9e6779dc8e114a3f2d2be7fe0ae193b473782a7b15aab08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38807e910f60217218943bab992ccaa367bfad21751e6eee7176138f7acdbf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a703361446c74029b678f290ff1aa8595da145488856cf98734f8afd472612"
    sha256 cellar: :any_skip_relocation, sonoma:        "cec304e5efd820ed26b1d8c5a309326c550d1c546ab54732d285b27db44eab43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab9f6e773b533e4677f9b790e8952f87a43afc3e4a8e76f5bf9fabd0ff98c059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c1cdd443addc2389e94611df8b9aa51df760573291613178b637ca374c04f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kor version")

    (testpath/"mock-kubeconfig").write <<~YAML
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
    YAML

    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end