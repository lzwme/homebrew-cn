class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://ghfast.top/https://github.com/yonahd/kor/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "cc447603010e1d4004ff7136ee9837a6a57e4985432de8fee8a3b7804b1603c4"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb3015cda43deb4795cb06b4efd669f1be758a3bafba39ddb780ea9f46de159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61fc602b7b6c55e0c5c4bd8024f72f219f7b0dbb89be915867290a066e4eb4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f920af5d3bc8522cf38a38559f72e91dadbb2d5633e2cd5d35efb77543dd1d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f1be6b29580b0d6e7a335ac395354ae6d5978d8c60f29b02fd2e6b77044a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8fe64c34c9b937effa67cffae8e6e3e55e0b83df60b7dac9b9f4c90035eea4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28b495233a8779ee02e9156cd711be644ac30dbaf77269eb2126646dd710739"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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