class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https:github.comlilydjwgnvchecker"
  url "https:files.pythonhosted.orgpackages73ac3cdb953fab79abfdea4c758b9560069605d8714f6e928dbc0e7c966332ecnvchecker-2.15.tar.gz"
  sha256 "ca910cd7d0474ff3283ad7e4478da908f76391f7fcc2b3d3c4e352318f56d9ba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0a1ebe1440437214aaa783e8df713f9c35ebb0b6e494144ebae0820ed026918"
    sha256 cellar: :any,                 arm64_ventura:  "da4fe819af5f8b379cdc0ce908378efcfb394ff5bfe7f2752ba395996139203d"
    sha256 cellar: :any,                 arm64_monterey: "0a206cdeaba3ee3a31339a52eec56fbf731c33d5b2b8858bf493634eb702720b"
    sha256 cellar: :any,                 sonoma:         "fb07dfbf7fd7fab59145b823fd77b206e41813099ffd1225f08d17968674b204"
    sha256 cellar: :any,                 ventura:        "55b53c8a2ac7bc4d6ec7ed1823312bba7c00aa6ca9f4f5e1694ac732dec3aca7"
    sha256 cellar: :any,                 monterey:       "04123f2f79e9c038cb4b612c47b2eb5b2d731c82e5565ac5cd62e77b769cb628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809994c96d39a6b0fcb5fffb1fa06656828a2481316897e744f4deb6e86bc854"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackages87879b237eda856dc3e72f2485e884f59fe0ee8be49aa2ce8eff3a425c388766structlog-24.2.0.tar.gz"
    sha256 "0e3fe74924a6d8857d3f612739efb94c72a7417d7c7c008d12276bca3b5bf13b"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end