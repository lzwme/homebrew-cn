class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://ghfast.top/https://github.com/helmfile/vals/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "ca292c2db8ef73417b86645c3c4be1f0a9809ede8600c0bf4d8b3620c0f27941"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c881ca488661e482cb1cf96623692bca2b74548fcf72e40b00ab441ec24a39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c881ca488661e482cb1cf96623692bca2b74548fcf72e40b00ab441ec24a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c881ca488661e482cb1cf96623692bca2b74548fcf72e40b00ab441ec24a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe0da053df827e73d7de718a4c481fbeeb4335a06beb6fa7b5c4e1c4c4e8687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9483408ffedfc270b652b0728af618159683844aa86b8427b08820a99c60c0"
    sha256 cellar: :any,                 x86_64_linux:  "278ad20af27ff1c5b53a8bd8faf163ab79ad7226edebc7efb438178a32274fd8"
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