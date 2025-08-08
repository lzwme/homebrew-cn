class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "f995e0a9518eee26d995d4a164cc0ab43fe1ac05da5dd0281da45677085be993"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5725e14ac33cfe251bd7045de9f693f303ef8c1033fbb73233c4a9244bb1d63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5725e14ac33cfe251bd7045de9f693f303ef8c1033fbb73233c4a9244bb1d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5725e14ac33cfe251bd7045de9f693f303ef8c1033fbb73233c4a9244bb1d63"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d749c1c74cd011212242f97c0493e061e9a90c69ea05b650b47140b7f51b74"
    sha256 cellar: :any_skip_relocation, ventura:       "24d749c1c74cd011212242f97c0493e061e9a90c69ea05b650b47140b7f51b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8157c7941c7cc6f56b109d40cd834ace708e0e3419465f6564e21f5e5feaf4"
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