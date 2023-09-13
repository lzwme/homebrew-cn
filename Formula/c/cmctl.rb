class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://ghproxy.com/https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "c2dfbc4997c46a81a10d9ae8837fa20fc612abeffdd71bc938b7bd8874aa86d7"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d46b8e916e4fce096edca889330b01849c7c2829ba5c24b830473844030398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45aa3a098d11dcb77c15ee927abc3aeae2108cdb63ee9f75c61515502519c6c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8a28dd6a4385cbc9bcc0d2789943a883dcf9ec7c5aa00bce9397c1a57a2a11"
    sha256 cellar: :any_skip_relocation, ventura:        "6a68ebd2082c41069e27e3458953c821137c4a86cc82d400f7bec968573883fe"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf918a38c9d00e54c53b6c860ae813bd3bfdefbe53cd244a921df0a6e1b7af3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b63d1f0282e596d9119469e60d6d75cc77b3490280a43c2395805c05bfc5ba84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f722b25e0fe1fc883dbc375d2e0990542b8ecdaf91836c88406cde90a81764f8"
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
    assert_match "Not ready: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
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