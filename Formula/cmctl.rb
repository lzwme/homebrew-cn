class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.12.0",
      revision: "bd192c4f76dd883f9ee908035b894ffb49002384"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fb3626c840bf6a3913633bcf811dc576f391c661e0b4c40c8fba3adc1b8e465"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edad7feb1ce8d91dcd716166c66c701ae30fa5229741d1a2a34be283aba633f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "456ab1887343d85328e74737ef7314c37b6cbbcbc16853cbd93b8923171be4b0"
    sha256 cellar: :any_skip_relocation, ventura:        "d4231fbd4e258ec759dcd13c2e9bb2c7c86111cc986f32b7d1565617611baa9d"
    sha256 cellar: :any_skip_relocation, monterey:       "38e045dec409ba54c1ca1b8650ddd626e7d2fb66c07b914122542a10a8215777"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c78af74282a76fc86fb86eb2ea702d48a353dd446d07d12aaccf31455fbaf85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efe347c103a0216d74bb207c2a2e922f5bf96388175562a7c23d1688267f245"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{Utils.git_head}
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
    # We can't make a Kuberntes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_empty shell_output("#{bin}/cmctl check api 2>&1", 1)
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