class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/a9/cf/8c5ac396f6d51cee5cfc5d4353bf64b9a1a1b00270699de09bb617177647/sslyze-5.1.1.tar.gz"
    sha256 "17edf03121904b28be4c75938db192df706e6be1ba172b8741135921cfd661e5"

    resource "nassl" do
      url "https://ghproxy.com/https://github.com/nabla-c0d3/nassl/archive/5.0.0.tar.gz"
      sha256 "b1529de53e1017a4b69ad656bcef762633aec54c86c9ec016879d657bf463297"
    end
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "9e3ce117c8b58e6a5d8b2fad1e3c7f70afc55999603ac5c21e406cfcc7074b67"
    sha256 cellar: :any,                 monterey:     "3cae04cb9e8ed1bee11dd14c64c510713fba8886088c18b7f83fd662c3dbfddc"
    sha256 cellar: :any,                 big_sur:      "9f3e2384c4fcb9c303e875c213bb15cf24a82d1e624443020f725183be704567"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dcb74982224beda452dabf47c8036db69e398255d5c3116fba1711e043cea53b"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on arch: :x86_64 # https://github.com/nabla-c0d3/nassl/issues/83
  depends_on "openssl@1.1"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  uses_from_macos "libffi", since: :catalina

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/53/17/34e54e352f6a3d304044e52d5ddd5cd621a62ec8fb7af08cc73af65dd3e1/pydantic-1.10.4.tar.gz"
    sha256 "b9a3859f24eb4e097502a3be1fb4b2abb79b6103dd9e2e0edb70613a4459a648"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/af/6e/0706d5e0eac08fcff586366f5198c9bf0a8b46f0f45b1858324e0d94c295/pyOpenSSL-23.0.0.tar.gz"
    sha256 "c1cc5f86bcacefc84dada7d31175cae1b1518d5f60d3d0bb595a67822a868a6f"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end