class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.181.0",
      revision: "48a8e87dede5c400bf9cdd204c7a9ded0b279ae7"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ca690e823b5d71f68d8694d703aaec94707a58a96bd19792adbc7e0d029c30f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "debbed4814cea44b18c48713c13502835cb06bcf29921b278240d02c330c2fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c54c40029c00dbd27cc0abf625fb5d4f44324d1e376d4546eaeb06230bb9088"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9f01804381f6ae223db599edb13deec473b0edeb8b6df7433033e9041f2c49e"
    sha256 cellar: :any_skip_relocation, ventura:        "a432b49f73717c5c41a9114770aa954b9a5658fd8cda7ffa1d1f6a4d74c3ce0a"
    sha256 cellar: :any_skip_relocation, monterey:       "d0823f62d05becefc55e506d289e28c489a63b700858238b40b38f36e8c22981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7ca6344295843e0fe988304c6314c177b1d4e0ebc46a4cf36b534a6bcaf893"
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