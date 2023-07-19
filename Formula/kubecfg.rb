class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.31.2.tar.gz"
  sha256 "dd1b0a21044914117edf04aa57b1e540d2608214bca993bd257949f4fe3a9d9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e96b5f7f120b58e7427b5d4d2f2340ad15d1e677da9870bc2c2996493e480c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a0b8cd3328c220087993756d6c57801427557c5671e601c15c16771d4d1eb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08005f20583410a58615880bc703860cc295481d9a537dc7753d9944c793f73e"
    sha256 cellar: :any_skip_relocation, ventura:        "87d8390adb9c140f149857729ff772a1b3a1b057ec64e04a749572d1196ad4d2"
    sha256 cellar: :any_skip_relocation, monterey:       "cf92e63677fcc3f30746413c5dcddab65b34404eabec687a1514f0cf7e85d174"
    sha256 cellar: :any_skip_relocation, big_sur:        "585f5ad768aedd9616d09c28c511ad1bb1380ed372f6a305831672d52f1a3f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403f8c08d1150b96c90799e78ca45f3f42cb6a2edafe000083aba06073342c26"
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