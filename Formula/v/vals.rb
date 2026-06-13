class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "8cde211d6e4e7e6f784181b3c8d1a8f41b441384ebfaf69611dce558afb45f11"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da62ccb7c455f377d39955aa150bba87d376119764f79a0d26d9f4badd9d5767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da62ccb7c455f377d39955aa150bba87d376119764f79a0d26d9f4badd9d5767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da62ccb7c455f377d39955aa150bba87d376119764f79a0d26d9f4badd9d5767"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d298cfce397605b129c856288c15544fb54c205fc3c0ed72c0142c6ca8d39ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3020ea02965e5618988415d42188ec28dccbfe9a193122ef5b11b15980f9d1"
    sha256 cellar: :any,                 x86_64_linux:  "195ad518d241994376cb5b87659fed5676ff71d88c963afb249daebe9ec0ceac"
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