class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "9883aebdc98e2ac6dab3808b508ef33e1fa3829084d21d2844546e5633e486b5"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d59fccd3837b3ff2fce68e919316d6b8a20f5e8319312874d920993a7d32814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d59fccd3837b3ff2fce68e919316d6b8a20f5e8319312874d920993a7d32814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d59fccd3837b3ff2fce68e919316d6b8a20f5e8319312874d920993a7d32814"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a96fb659edde7a2559b3d31ababfae095e07de63477aa4942511077f4ebfb4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babfdcb6017e6247e4895b23007902a552854742375cb1e0fcecc417af9affd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a620bf9ea282e17eed6e043bc96420c711ea6907ee4a1c27b883cfac2027e644"
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