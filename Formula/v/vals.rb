class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "ed53a036c82d24384ccff3cc875213a467a97ba6745814b07ddb1d234e9aa1e6"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c126415dc13e99669ff7afa0e014313cab6911f35cc4853ac6321d5e7bf5ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c126415dc13e99669ff7afa0e014313cab6911f35cc4853ac6321d5e7bf5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c126415dc13e99669ff7afa0e014313cab6911f35cc4853ac6321d5e7bf5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8081a5b44b798c674abd7a947fffb89ec3013d269935cee94fadd72d97d8700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9836b9b5cbc7553c92a208417b98e40f90c5a0c700e84052354c4a948cd7e739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bbc1965389d837a288d53e4b55f94320687a305b42fef0e16856fa8b92a28e"
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