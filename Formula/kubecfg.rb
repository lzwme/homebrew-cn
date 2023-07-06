class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.30.0.tar.gz"
  sha256 "dad500f98a34816d27d3cb346d9273a5ac731306da357577351a4f537dd4e0c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c66017b7325524d029a89c98d1311a87d504426cd04e7da98f722dca4d875e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90cb1db080105b8242dfb75893186d0a43136d71d89e267cd5600adcdbd8c3d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84ddf1c9089c20cd0a3ed4295920efff5dff3256c8affa2d167b1b374095b668"
    sha256 cellar: :any_skip_relocation, ventura:        "c1ee9506a9a0a0d0b4d774a1a1407b1cac0cf6c703645cecc4eddc81313bc16c"
    sha256 cellar: :any_skip_relocation, monterey:       "02bdf59b5bf9e7cf2e7be50d1301ffb550f478bcae775895296fc12e74cde459"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c4fc046f8e1a4714684fffc0c81ed29da6bc1c852e5391376b08d7696bf41d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e1261461cf68640290b0c7ed8d8cea412196735d1e423dc60d6851947d2d49"
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