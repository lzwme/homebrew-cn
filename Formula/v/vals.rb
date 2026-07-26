class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "861d05c54e8f5461832ea761926a4cbc41b2c252c5950184804c4307185a79b4"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1620827cf40ba2c7684ba223c81c7b0e7e7ceb3e8b0e419bfd032a199e91be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1620827cf40ba2c7684ba223c81c7b0e7e7ceb3e8b0e419bfd032a199e91be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1620827cf40ba2c7684ba223c81c7b0e7e7ceb3e8b0e419bfd032a199e91be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4744d2cfabb2b01d5fda01996b4c0e90be0aa0d620630563d8174db9120be763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "179360267b595ea5fb517587a5d65c6cbda752aea37b7014f50347e94d270f73"
    sha256 cellar: :any,                 x86_64_linux:  "32116145f4a866f88fc23bfa0d66f22569f461f4810653645bf9df05c874038a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
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