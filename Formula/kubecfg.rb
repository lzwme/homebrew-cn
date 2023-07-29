class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.32.0.tar.gz"
  sha256 "efc86409388a1a69c0d701b448a563e3746c9b63f2a4f8c76f4eb5038a1b9791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab55f8e8f520095dc30cb47470ab4088feff60f07fcf398f82c6ae7e111eec1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "029f0452aa89ef52384e097b05da63a36e97f472e94b3c3f071e1d877faf965b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d7dd780836f5bb6866047e3787e2f3b5881b233d114661fb49ee5ffa7e39778"
    sha256 cellar: :any_skip_relocation, ventura:        "341339ab70b11fe2aecb548ca60395a226ae02529fb3ca4c8c98b108aebb5617"
    sha256 cellar: :any_skip_relocation, monterey:       "b655e86b7ac6c13a4e1511b266f91fb2445ebf49a404b27cc06473ad4c943857"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0547f8da5b9f1c39d0939e3e53dfb2560b48774ff1a1f4164a64b09f01059d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77938053fb78a8b51631c420c348ad0aa0c47f572dcf58da5ce2ff08a70c06d9"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end