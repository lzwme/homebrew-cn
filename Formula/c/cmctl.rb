class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https:cert-manager.io"
  url "https:github.comcert-managercert-managerarchiverefstagsv1.14.1.tar.gz"
  sha256 "d34517ca240dbbd8ad3f19b76ed08f597f220bbf901e8204907ba81fb020e72f"
  license "Apache-2.0"
  head "https:github.comcert-managercert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eac5afefc0a2f4c8206c5c0dfe0585219cce97804ad862e8c3e30232ac3c50d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e61ef67855078a44533ae6c7aef898370a7c2c140c01567d59cc25e8ffb01f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e72804bed7408de0f278a38997af45db55cb55dfc022ffbc4c9cea3518165f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "da780eacb419eb656a943688231c4994f90be42faf5336a515782e94c1a29b7e"
    sha256 cellar: :any_skip_relocation, ventura:        "044ed21411a5b4dc11b4002cd832c7a369b708bff0d186dbb53c980553086730"
    sha256 cellar: :any_skip_relocation, monterey:       "35570f7af12921af082e5f1443ad20a97fbd5f6d001472446f83ab2e30b5623b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c9fc0324572c2143e53d0b21d1ca4a7665e90645aa25b056f2a704adfbc2a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcert-managercert-managercmdctlpkgbuild.name=cmctl
      -X github.comcert-managercert-managercmdctlpkgbuildcommands.registerCompletion=true
      -X github.comcert-managercert-managerpkgutil.AppVersion=v#{version}
      -X github.comcert-managercert-managerpkgutil.AppGitCommit=#{tap.user}
    ]

    cd "cmdctl" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "error: error finding the scope of the object", shell_output("#{bin}cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath"cert.yaml").write <<~EOF
      apiVersion: cert-manager.iov1beta1
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
      apiVersion: cert-manager.iov1
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

    assert_equal expected_output, shell_output("#{bin}cmctl convert -f cert.yaml")
  end
end