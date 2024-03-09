class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https:cert-manager.io"
  url "https:github.comcert-managercert-managerarchiverefstagsv1.14.4.tar.gz"
  sha256 "f9b68c18840d7590e3c0691d9827b63ede30cbdcd21604312034f32d23bf1a3e"
  license "Apache-2.0"
  head "https:github.comcert-managercert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daab6a2b88667b7c544428150984ee0a3276119273c5440179ac42b781fdfd10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3819b47878f4fc6b6e208bfafd52e5a0aecf5bb185475fa278f033d337db6233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43c05831eb82df155153d48661fa2e2ed7450aaa9b1822b1f6201b9222abbbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "860539e81216dfb84cdbc016430653ff74f90428c90fe4628bdd95081b844801"
    sha256 cellar: :any_skip_relocation, ventura:        "46d78ae95edd8df00098a6d1e175cf6bb71cacc45c1f88220bfc9f2474340681"
    sha256 cellar: :any_skip_relocation, monterey:       "9149d06dda93e395192ada9cff2e1ff2217cb2e11ea26557e7b15b0e0324ace5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bdc627df512603bfea295e5e144cbf39db2b0e68ac08ff73ea6064b2c039d58"
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
      system "go", "build", *std_go_args(ldflags:)
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