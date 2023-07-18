class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.31.0.tar.gz"
  sha256 "7317c10e3620115e823ae56e7a9a119c1fa504b22f0063fb21376edd7767b21a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7db5029a28524b85b532ad937e628e2e820b9ba529313891f8d0624ba0853110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50393b7050f1301e148ea542ed255f643d750cfd0026dc7783022248b2698af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4da2729b458721318832c70926bf2c501d89d93cbcb280c7ac22c163408eb86f"
    sha256 cellar: :any_skip_relocation, ventura:        "c12816a95267eabb3fb3df4741549a15cd1654e7cb059de3e6c20fabaafe4927"
    sha256 cellar: :any_skip_relocation, monterey:       "57b61d936d39f3301d541775a2dca488cde966534eaf8e2702d308607a3965ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "be454e13e455ea6546abcb70a42946efdae791b3fb36ec4c9c44d4aaa9dbadf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64022938bea3ae961b53f0f3387340ee8cb512e526a6c716d3636bc84d6dd0d6"
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