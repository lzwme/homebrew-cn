class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.147.0",
      revision: "1e027c53f66aa1680438166fc153aaacd2b3876c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af63b2ef53ee65329a9e0a075ed70c0fbc9cea7e6ba28ff5a4daf6e6a6b9b7c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4a917fe08b0786a8aa81baaee11e15b487f9c232b1fa53026729a02b1dde3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b49743bc1053f3cdc45c11a4fc0326d215543f04f3152c796bf2cdc83d3b4341"
    sha256 cellar: :any_skip_relocation, ventura:        "68aba0bee5e32c1f2ffd3ea4135ae505e96dd6b4bed21ec9d9db5735ed884481"
    sha256 cellar: :any_skip_relocation, monterey:       "a162ca372ce88b143227d648d5f210bd69870a81374e2f8a3a156895a89f1591"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5aaa9d8d04d1ab7145e91ab2e17d1d21b26be29d09ca9556f7f94c1659f3bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feccbe2f32d660d13d622a203d77e444cec17f81e63488f0fe628e6c9e73a5c0"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end