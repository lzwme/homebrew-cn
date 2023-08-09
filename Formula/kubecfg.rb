class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.32.1.tar.gz"
  sha256 "913399d70aa0bb9bef59319e8d54734d3e3602ee9fbb173ee5a63acae1bb4e71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15fe188a8ccc43203e73934593cb481154ca1e5bb9fd3c8ce5bb61ad31fe786f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fbbe77b44141845d1abb7e05f5b435a2016e4546697cfa5f8c6f5c937ff649a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39160c4d651fac21c19da34f33e943951448c492d352a91a8750b2fbf9c8a9bd"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4c73012fc2088073419c7244c6130109d5ae5a00a9cb51cec630c2b21de666"
    sha256 cellar: :any_skip_relocation, monterey:       "28f2387acabcc80b9c45beacf519f75f325c5a49e82b946891d699a3f8481802"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a565d60a2460f919e1edae06c2ee7bbcb365c7bf67e3756669a945d6cd65ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6549c1022c0de7201b55e160217b1c348e140ff7d34c69a5847328d947b7fd2"
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