class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.180.0",
      revision: "7630270608990cda497a5118113e118761600c25"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b8591ef0a0c788e22742e4de6ab6ffd541b00697544b7be6c1dd4d8b10e261f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bd9d3b0442a45983957c000de948bfd9665a53223639ee4a6f45cca3678d8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34afd2e8dbf54d7ee34a0aa85942f35140610532780ae3fb6e2e11e2c79166d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e57b0678437cd7e152e5a3253e24a0a7fbddd352bc63e892b25cf7df516ebe10"
    sha256 cellar: :any_skip_relocation, ventura:        "e0e4b1d9738baba3f88daaa2ba52246f570423ca81bb27e67156b8d0c4823bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "0aec151aa1013fb6bd80382ed5872b1749009690716cf2ae0a6a22d95709bd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73a88d1a6f96e1e348e26a68e127e911bab25fccbe2fadc2377ef90c366b3d2"
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