class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.145.0",
      revision: "7863d0ef2df6ab2c537a3de0496ba9c371014875"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ba0d66aff571ee1b0e4585d0dba024b990138f858e972a7b90d56574993313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e993471828aae4a77ab3a1b442e36ef86dd8aeae7fcc779ad79e72016c525cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62aff0be3e0a77f6c06def7ffc058bba90f639dce182ee7d141ef97162168925"
    sha256 cellar: :any_skip_relocation, ventura:        "f78e0902a41bce149387cb3be407f2afe6282bcfe3ef0f9209f73620466da8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6e3b1669e6be32c9583363c48b3524c25e6d6ebbd860e27ba6b5bbf8feff12"
    sha256 cellar: :any_skip_relocation, big_sur:        "3be5672ed78504c30e81e63612ea34d997a7c679d81eb5abe1c38b081f4cdf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9644a82b0e5eabbd52135e2db57f94d6339dc6eee898d5bdbf838b313574b3"
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