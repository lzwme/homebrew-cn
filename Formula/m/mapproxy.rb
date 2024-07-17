class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https:mapproxy.org"
  # Should be able to remove setuptools from pypi_formula_mappings.json in next release,
  # see: https:github.commapproxymapproxypull863
  url "https:files.pythonhosted.orgpackagesba096ca59563371cf5a0839a1bca32f277f00dc737a213b1bfa72e5ec0dfeca6MapProxy-2.0.2.tar.gz"
  sha256 "1f03b982faec5bda40af3e112edc4d7c29a216a6bce40022eb004923e17d184f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "daaa0d4c12d3be15f3ac5595d1fd3274758e80852a2d0b13fdb7f29a1ab965ae"
    sha256 cellar: :any,                 arm64_ventura:  "dc4f06880ab4c0353bd04ccb5fabf874701f7543672687f7b7153ef86be962d3"
    sha256 cellar: :any,                 arm64_monterey: "2373b3fc7c44d74b575c11cb2d74148b6c7aadbcb14fee4e5c3363ddbd6df322"
    sha256 cellar: :any,                 sonoma:         "358a8838bef33e0aa34f485af83444537e741cd49336e66418bd55476d752f74"
    sha256 cellar: :any,                 ventura:        "7f1dc483b3c27850eb9a57ac762a96bb7ad3ea2d35924375c9d25bcbb07bc9f2"
    sha256 cellar: :any,                 monterey:       "98cae1a577664c5161ea66e36ced7135740e22578d4c6d24ee7e696ff28b0752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2dee44fcd932d61013606e970357aed7cb8767bbe7498dd91787fc6da8e55ee"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.12"

  resource "pyproj" do
    url "https:files.pythonhosted.orgpackages7d842b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath"seed.yaml", :exist?
  end
end