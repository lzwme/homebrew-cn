class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://ghfast.top/https://github.com/cert-manager/cmctl/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "3de4456c6f36a143992661f7357a2bd111b224a72ce7b61d83bfdb3679f36a96"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ef6ff0e9885b526ab3d84f5c6db013c2214267c64811f45c968032dc915d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0acd013714e2ce5175f24b1c5092017de5adc233c7f22268597a24521cb3b506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f5129a1f9548870ca527149286f7ede6b2597db80d222a15b638682f4fa45cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "14fcef525d7f0e747c1e26b2f2cd15022c5f4c8caf43f092e4315b0cdc3ebe3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c576f8f56fa35bfa56a6b10d192464bcdf45a70b9276fa428a0a82b6679eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "201aed9e902e52062a6cfc63888056967554be57ede6d2da1f7340c185cbd51e"
  end

  depends_on "go" => :build

  def install
    project = "github.com/cert-manager/cmctl/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/build.name=cmctl
      -X #{project}/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~YAML
      apiVersion: cert-manager.io/v1beta1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        secretName: test
        issuerRef:
          name: test-issuer
          kind: Issuer
        commonName: example.com
    YAML

    expected_output = <<~YAML
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    YAML

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end