class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://ghproxy.com/https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "ef6ef828ecf8a334ea9e3f3b21b4b19985a57aac053ddf11972f15d9a2102b80"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "863b588fe9dc421ece1ed76e0d6b8d52fc195e6e040a9dfef2bb58c6f9a85e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba17610dd52d1609ba0d31749bb691659dc2c5b2bd50f0cc811db05a27f924e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d1616e3ba15e93e9b34766e1e3bd2c62548739fddf42187181ccbbbb99fef0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0964437001043afcfbcdfaaf554331b4b2932d4003c6d047b8b829ac99ab4b41"
    sha256 cellar: :any_skip_relocation, ventura:        "12e8be13af37b82680ab58f3986f7c64b73b537850cb5884633f9e39ef5ccd56"
    sha256 cellar: :any_skip_relocation, monterey:       "59e43c3b280699648af245447eb477b9ca2459a48718ca4bbe213ab9c550fcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427f5031237d6d73242ea344fdf373e017d54b81641547dbc08479b644ef6195"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    cd "cmd/ctl" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

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
    (testpath/"cert.yaml").write <<~EOF
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
    EOF

    expected_output = <<~EOF
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        creationTimestamp: null
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    EOF

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end