class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghproxy.com/https://github.com/kubecfg/kubecfg/archive/v0.31.4.tar.gz"
  sha256 "683debed73de83aaf619e5fdee49dbd4f536ba661412a8c338db5d165158c397"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f3aed766316a375702dfb786015f4648054869ac3d6aaa9c41a0974c594638c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9fb9e564f062deac85f58a5a75ea28cc315b9c22537756a58c0ee92b27f1fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd062223bb16cf4f2fe83fea9da11599d0450b04181480c37c056b85483f5d20"
    sha256 cellar: :any_skip_relocation, ventura:        "8946bd16be301771892033a7be7b77fbfab6082e0b8f612f984f8afae6a70e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "896bf78c976e05e314a21d7065236ccd85dde03bc701fc4301f7cc65114250b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62069f8906551dfc968affe0213abe9d3a77574981f16d3885bc263607023d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffa0fa7ea917b7cd344041d8ef2e2423f112983336ace3af8ed40dc61be7be0"
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