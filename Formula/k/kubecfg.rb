class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https:github.comkubecfgkubecfg"
  url "https:github.comkubecfgkubecfgarchiverefstagsv0.35.1.tar.gz"
  sha256 "b155823bdfb5d48d0ee93c395fa6f1c777fa1e91cf9f87c5d518c432debafa73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988de00eb91dede0a3fc2f92e8c7f730ecb6d3082d53f83bab530319d33a73d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631492ce440899bca234188252babb2b8cd810075f24baf09378d2380a9a66fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "281d9f50dcdfe23192fcbaa1d2dac49fc7b7a7e5afacb5ebba2cae5149efecf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "da919317db2dfd838c28518d223a815c32f6b1b2c7043b2d0f4c9b74d2a31802"
    sha256 cellar: :any_skip_relocation, ventura:       "2ae1628aa64f9a19e6768b87e09c89ae1804b4a4c2913111de764d1d71890d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9267205d670d6b283418680015fbcd3886dab38b6d2804b67a17ac0aaf5a954"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin"kubecfg", "completion", "--shell")
  end

  test do
    system bin"kubecfg", "show", "--alpha", pkgshare"kubecfg_test.jsonnet"
  end
end