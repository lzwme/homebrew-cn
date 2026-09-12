class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "a97c8e9701713c49ee30e0459948d90f59bd8bb37bea829dfa6bd01a1e4ebbf4"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97bc719e1cb25d3a6baaeef90ba0aea10746c71b903bdbe04e18b7c0d4dae5d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97bc719e1cb25d3a6baaeef90ba0aea10746c71b903bdbe04e18b7c0d4dae5d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97bc719e1cb25d3a6baaeef90ba0aea10746c71b903bdbe04e18b7c0d4dae5d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3d3b0cc04ccbded6e79debba075c9d3dc03eeba5af462feb98ffa32c3733212"
    sha256 cellar: :any,                 x86_64_linux:      "074f15e0e38a79fe15ae4f3959a351905fb672e729425e576a77e6c5539cc9b0"
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