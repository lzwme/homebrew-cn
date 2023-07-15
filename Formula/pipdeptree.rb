class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/0a/b2/2508e11f44e0e7b136555175f21c121f20642d43ab2a09797b178e968834/pipdeptree-2.9.6.tar.gz"
  sha256 "f815caf165e89c576ce659b866c7a82ae4590420c2d020a92d32e45097f8bc73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5912f5355739e617105547a714123c007aaa1712c719cad88bd95dd4304385d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6312c1e03334826264f97b9daaa93eb9386d9620581828665ffe1ed8f77a49c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea0ec5fbd3820ca5c55c6dcec01e2c467056568e21098b10797b08c8ce5c8db3"
    sha256 cellar: :any_skip_relocation, ventura:        "0906fd5e436128dde98307e52407b85c34811c95d9811baefc43e2baec1776e9"
    sha256 cellar: :any_skip_relocation, monterey:       "0d86f05f18cf25bf7a6bc0977f0a5f5692040e2a90f962e49f120b591f05ab05"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b9c426f9128d719c42fd9d0c552d6a188c5b71a40e41b49f268208e92a18e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c1dbf62620b1ce212073b0d79778276b559785edf68662adfe1888277cc36a8"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end