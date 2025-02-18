class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https:github.comhelmfilevals"
  url "https:github.comhelmfilevalsarchiverefstagsv0.39.2.tar.gz"
  sha256 "188e27aa5d6ea8585775034b9674244b55265b476d8c8b2c188bde1c628ad54a"
  license "Apache-2.0"
  head "https:github.comhelmfilevals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb21d37d428b6e3c83028cdc34cbe3a0ad9fb7825d67d72503544b8ad830df37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb21d37d428b6e3c83028cdc34cbe3a0ad9fb7825d67d72503544b8ad830df37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb21d37d428b6e3c83028cdc34cbe3a0ad9fb7825d67d72503544b8ad830df37"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc238ca0a7cf1a15793d96b3da7164b03a38f6fbc2c04e17a77dd7e452c72aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "cc238ca0a7cf1a15793d96b3da7164b03a38f6fbc2c04e17a77dd7e452c72aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d9a33b7e9e5b3b81f61e050b08b34c5a23da781838f613c90b4ac54a02ab8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), ".cmdvals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vals version")

    (testpath"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end