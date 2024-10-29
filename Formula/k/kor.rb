class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https:github.comyonahdkor"
  url "https:github.comyonahdkorarchiverefstagsv0.5.6.tar.gz"
  sha256 "a655d04eadde49c23fa8171248423304adb6db1da695df19b28863b90cae8e3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28238df1bac4fe98410a6fba34e5498d6eba1c9140fdf2158379d10c473ce53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28238df1bac4fe98410a6fba34e5498d6eba1c9140fdf2158379d10c473ce53b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28238df1bac4fe98410a6fba34e5498d6eba1c9140fdf2158379d10c473ce53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba38a28dac4a58367ce3f4277013227adedd4e9b3ac16abbd0624c050a6aa431"
    sha256 cellar: :any_skip_relocation, ventura:       "ba38a28dac4a58367ce3f4277013227adedd4e9b3ac16abbd0624c050a6aa431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df19b69c5ac4a9c000d0b1df27c1d955d1676c19ed64e6afaa763d10aa9cf47c"
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