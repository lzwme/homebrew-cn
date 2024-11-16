class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackagesa709cb6243a1bf761916a24d0cf58b7719f68d8975ba4491916d5ad7ed540e3dcertbot-3.0.1.tar.gz"
  sha256 "4d573635840bbcc1124a2176e7188e69f6e3210f9ed94e20839547f07caee2b2"
  license "Apache-2.0"
  head "https:github.comcertbotcertbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbde13cbcc6e5feef5a2537a72d6c0bcb9e5ddc86a9e8428ac867acac8d9c3b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbde13cbcc6e5feef5a2537a72d6c0bcb9e5ddc86a9e8428ac867acac8d9c3b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbde13cbcc6e5feef5a2537a72d6c0bcb9e5ddc86a9e8428ac867acac8d9c3b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8bccffd9210ae0b1a801f502bf68c948f9d67361df9c1bb36a505f2e519c502"
    sha256 cellar: :any_skip_relocation, ventura:       "a8bccffd9210ae0b1a801f502bf68c948f9d67361df9c1bb36a505f2e519c502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b11b2966938fcff0616fb123e3382bf82dfee1d50fb8704d4d64d63c5970ab"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackages2a34d6d7064afabe02f0043e5015aab664b67fc8bf049e81ac9220526afed3ceacme-3.0.1.tar.gz"
    sha256 "2f4ae207c8a6791a2bc74cd18d60274766f483c2059145b0142cbb43e761331c"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackagesbca0e156803d229c63c317442d1a23f6218201971fa2f41261e5fa3e13b64cbbcertbot_apache-3.0.1.tar.gz"
    sha256 "83af7dfc1bff6149e810426038bb81ad2b8b4261b3d8b969c8be8321fba24df4"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackages2ffedd474bb102881362703de7cb3b00c5fb147f8de1eb72a52542e63e89fb78certbot_nginx-3.0.1.tar.gz"
    sha256 "2507fdfb3401ba58b24bac9c3722b4e1641ec100e5b21fde0c518b2c77c6647b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "josepy" do
    url "https:files.pythonhosted.orgpackages2ccd684c45107851da4507854ef4b16fcdce448e02668f0e7c359d0558cbfbebjosepy-1.14.0.tar.gz"
    sha256 "308b3bf9ce825ad4d4bba76372cf19b5dc1c2ce96a9d298f9642975e64bd13dd"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackagesf0d26587e8ec3951cbd97c56333d11e0f8a3a4cb64c0d6ed101882b7b31c431fpyrfc3339-2.0.1.tar.gz"
    sha256 "e47843379ea35c1296c3b6c67a948a1a490ae0584edfcbdea0eaffb5dd29960b"
  end

  resource "python-augeas" do
    url "https:files.pythonhosted.orgpackagesafcc5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc8db722a42ffdc226e950c4757b3da7b56ff5c090bb265dccd707f7b8a3c6feesetuptools-75.5.0.tar.gz"
    sha256 "5c4ccb41111392671f02bb5f8436dfc5a9a7185e80500531b133f5775c4163ef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.13")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpathpkg }
      pkgshare.install buildpath"certbotexamples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdatedtoo newetc.
    assert_match "Either run as root", shell_output("#{bin}certbot 2>&1", 1)
  end
end