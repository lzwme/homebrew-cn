class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/ce/ec/885e8dc0111ba546d738c04fa067bf095a9f120f581ef3ec8fe416b9b6ef/MapProxy-2.0.1.tar.gz"
  sha256 "c8e2475185410a8d0e0f4eaccbe074356f95e280bfe6c357f917b2cbbba1e061"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70fea27cd22be1b66e35c586d9778ff2a5fc81b1bd644722db3597d2a54f75ba"
    sha256 cellar: :any,                 arm64_ventura:  "56c20ff98618986d41f2968c842a67fefb42808f9d812e646cfe70ae904df041"
    sha256 cellar: :any,                 arm64_monterey: "25a5340c36967d607035d0e49bc49db1047258863afedf2117658a0b7caf7c6d"
    sha256 cellar: :any,                 sonoma:         "a0a4ce04b27a3588723954bbc1a3495d9a0af2b3bbb1382a81df43d0f5d9049e"
    sha256 cellar: :any,                 ventura:        "afe0da85b97ab8c6c90c2433aa49fab7b16774338a076def09e7cdb548fb11d3"
    sha256 cellar: :any,                 monterey:       "974aba7f8abc40d9d46d7341299da34d524c93bf88ff57967dfb7266d060d9c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed77ce29b65a61eeab5aec1fb625397df7293481ac23dc261d73e38d021060be"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end