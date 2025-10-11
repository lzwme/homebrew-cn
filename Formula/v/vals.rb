class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.42.4.tar.gz"
  sha256 "cd0d000a68df7db53b8293859042e776ccbca6dbd001fbd923a329797fdbf9ff"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd0677f69ee1118d5e8c42339f0e0987cc9affa4f05cec4d9c64c6deb8c0164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd0677f69ee1118d5e8c42339f0e0987cc9affa4f05cec4d9c64c6deb8c0164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd0677f69ee1118d5e8c42339f0e0987cc9affa4f05cec4d9c64c6deb8c0164"
    sha256 cellar: :any_skip_relocation, sonoma:        "6238133f4742520903f5a085623763f002afe5db5225382c3f29d7d39a869847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447e3de3a5efbabe9db5808509e05c916f0a0d65de592318ef8627bb13462b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3790cbb12224b2ee0e6ef548dd9810381a2aa704f0cbb86ff74934ff2fd79ba4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vals version")

    (testpath/"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}/vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath/"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}/vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end