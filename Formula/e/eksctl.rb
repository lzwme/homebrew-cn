class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.199.0",
      revision: "228a27121c9aa65ba96df2033003be5a08e439f5"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cefb79e437d501f7d34678261058c311ff7c139bd918658406065e89e3c49501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da35f3fbe65943a8f8e2490fea443230bdd34d37d7692907bb8e96a020aa5312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8adb33f06150f20d3f6e7f71a532791f4244db7462a5fc59f1214a66bf077d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "58c607191c35a0ac2165ff7fb903e4517b4dbc857a72bcb2551ca7205f02c6c6"
    sha256 cellar: :any_skip_relocation, ventura:       "e0c84e44bd5d0bde1e96a75534f550f6e5c781d49dee57514bd152953639b6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e081a82af425747600243dd658a7eac006a7d8ec3d5d54875fd2730fc378f9ac"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

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