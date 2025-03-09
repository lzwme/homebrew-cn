class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https:github.comlilydjwgnvchecker"
  url "https:files.pythonhosted.orgpackagesd9e369783bbb2a81098a7c6cad793b3cf8fced05d1d874b4492e3baf85bc270envchecker-2.16.tar.gz"
  sha256 "c17ee55fbe14a8f8b38c339cda6dafad25279b86ef3a268695533d4fbde2ac86"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "686023c6a0a3dfed64bd7a6d0055504c9aba23f7167d52b9633eebadbf1984e8"
    sha256 cellar: :any,                 arm64_sonoma:  "5414a54705945d0601f935340af272df3849366a3974b3fc55c1d7e0a88f96b0"
    sha256 cellar: :any,                 arm64_ventura: "eb2e3cdf1413ac91aab74b95c07f29291d2f191345c6ae1b7093f0dd0c8d5dd3"
    sha256 cellar: :any,                 sonoma:        "1715f0c344c9ed592184361ae35a3efac29e3da1a0025850e2e0250a53e9b8dc"
    sha256 cellar: :any,                 ventura:       "7f7d3c35002dafd6b250fa2abb5ffe2e40b7716ff37497cd86ce5a592021ac24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8320d361449b9d258ffb38bf9e6ebc70820d2ef4888ac1a7f9bbb1f719ace5a8"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackages7135fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackages25fe578db23e17392a8693b45a7b7dc6985370f51dd937157def8ecc7b20930dstructlog-25.1.0.tar.gz"
    sha256 "2ef2a572e0e27f09664965d31a576afe64e46ac6084ef5cec3c2b8cd6e4e3ad3"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages5945a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end