class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.31.5.tar.gz"
  sha256 "7f783645d5dfc2254b88ea3ba12a2dde5693a0e1f645450bc08131eac9965f29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e332d912a1a7da3122cd4612153bf30a7938176d08266713eaaa3427b3de90a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fa46e942410fedb4571256adc43021e9773e12461ec68babfbde68dfb00028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7eacb8ca556e9c3bd92a699188fe99cc20d9871e47064960e762ea13fa795a6"
    sha256 cellar: :any_skip_relocation, ventura:        "4588a2ef5308d49e9522e1d1336e8182f3f3abe2fc41610597ce853d82f6bfdc"
    sha256 cellar: :any_skip_relocation, monterey:       "9334fe86fb775b1a2da58f4e4b5f930b3be29f329c88e49afc586431b66a536e"
    sha256 cellar: :any_skip_relocation, big_sur:        "27dfbcb01417cf24e17af0b84b79fc168ed4d8303725324eac2092dffd200281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa1c44e467da8ba6643e8ead566f7eabf52c456829b90431eb50071b9c468b2"
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