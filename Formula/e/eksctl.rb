class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.178.0",
      revision: "fa79d2e0b1af108b714da8020809bec218908288"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b900704b7fb55d32e4e2aa8b09316d383a60129458a5e9fd0477538b2075c52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf76b9b0d541ef07010978631ac9a694845daac0d424929513abebce0471cc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19ad7d28d85b6285526f434bf9967b7ae10797d35d49e5c4f63fb9eb0563517"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89f22549dd20e69a42d4a193b5d4ae7472656d4d1f2de5af8e768048efe4b74"
    sha256 cellar: :any_skip_relocation, ventura:        "231efa0599bd22841741323a3aa263bc7f5bc217790f2e243385ccd43c989b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b436f7effb2c2dbbe96e07e9ccfd1c9096fd9b3eb77c57ffa72a40527a9ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81f3904955eb69ce043a16e9db2daeee6ba783d38871912feb20df81a083917"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end