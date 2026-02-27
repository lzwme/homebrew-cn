class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.43.6.tar.gz"
  sha256 "7044ca59b88294b116d3b4268ba5cc133ba736e6ebdb354fe454fabccf7d45c0"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "974abaa8264d7626a991a5a320705ab30e6e6f2e0ef33980c1a9412c304833a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "974abaa8264d7626a991a5a320705ab30e6e6f2e0ef33980c1a9412c304833a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "974abaa8264d7626a991a5a320705ab30e6e6f2e0ef33980c1a9412c304833a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e37601ba53f88262ba177e7fbd0cf1c8e20a61ddcca94a30fb7705d844447b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a850e46bca622a2e7177d0e0782939e8e732ce3c6f22dfbd3dbfe792b63d2e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9099c211b65464b65bb983464d879c738ee2492c231a2c6187e2bbf4843ca17"
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