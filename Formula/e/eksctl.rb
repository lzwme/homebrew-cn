class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.191.0",
      revision: "c736924d65ae9805e35a3505a960cb3c97c14f49"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eadd95b2ed448a68bbb7e93ab80d592e73381548839173c28da3f4590783fefa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b63c7f7aa5d27c79aab593485022889f4868dc3ab354be6229a22e06e594ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90230cf93977c3b00a6cc075cfa7b0e203a96f2ddd68574ddb411cfe02526fac"
    sha256 cellar: :any_skip_relocation, sonoma:        "7442e32879e1f6a85daee7cf915075fd59670536c1249d82378902da4f2102be"
    sha256 cellar: :any_skip_relocation, ventura:       "78578c1242244a2a16e5cded9ec78f04ba6434bce6134169b942536873192707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab340e7a36d3889d3ef2cd267419266b43f676e94f57facaccd8e523627d628"
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