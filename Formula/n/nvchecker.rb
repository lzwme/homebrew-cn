class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https:github.comlilydjwgnvchecker"
  url "https:files.pythonhosted.orgpackagesfb9972e1057e035f43dfd11d8b07fa19881c55bdfadbee31caab961b0e9a9fcenvchecker-2.14.tar.gz"
  sha256 "268c01dafb5a111cf724dac005637b636e8366dd5bd37587a3128b503734ecb4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bbd05a02765888639f4fdbc190e48e726c832f0c5e9e73c6752f8868c404e727"
    sha256 cellar: :any,                 arm64_ventura:  "f95b148a01a5c573a601852a4c8e77a47092165f3fc6e8f2ca289c883ddf5052"
    sha256 cellar: :any,                 arm64_monterey: "1e213544d2d4ba4f301e109c894b48734056d0edd3a7f4f5faf7854719a70be9"
    sha256 cellar: :any,                 sonoma:         "082370292731452be7a0ce94e68f12d63e1bdefebed28489daa6285078057a85"
    sha256 cellar: :any,                 ventura:        "c56f167563da44f21e1fc4a21c268e78db1df04007a322913204aedb219da97b"
    sha256 cellar: :any,                 monterey:       "dfdb0ee55df8fb25b1adde27fd6ace6118c35d7c4282149b8620edbad41ec8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1446b0873dcb971f755e20a6f8c98c86efd58f0d5288fcdcf9bd516bd12b6c66"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackagesd1ac87aedb7a9ba52f645b9d29a7f48bb12a5c6b7e204b8137549fbe4754b563structlog-24.1.0.tar.gz"
    sha256 "41a09886e4d55df25bdcb9b5c9674bccfab723ff43e0a86a1b7b236be8e57b16"
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