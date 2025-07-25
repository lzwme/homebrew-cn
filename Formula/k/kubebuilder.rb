class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.7.1",
      revision: "9c991d34829671ee7dae2ddbd0954eea82b5e2a5"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddb1b2cba245d9214dd26e854b636d9b2e665d96fc41f80f9367b64b7d0e9834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddb1b2cba245d9214dd26e854b636d9b2e665d96fc41f80f9367b64b7d0e9834"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddb1b2cba245d9214dd26e854b636d9b2e665d96fc41f80f9367b64b7d0e9834"
    sha256 cellar: :any_skip_relocation, sonoma:        "546d5f557beb625ba7bac6e7faea2f247da1fa0dd908121def09943d0b05daa9"
    sha256 cellar: :any_skip_relocation, ventura:       "546d5f557beb625ba7bac6e7faea2f247da1fa0dd908121def09943d0b05daa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2763f434874cd51686411ea5106436cee50b11569b21e85e68506d947e160bdc"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.io/v4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~YAML, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end