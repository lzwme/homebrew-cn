class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackagesf7e36e20eb27fca5fc4e95d43a53f96d5e8f72565983f9acd64b840c09c3777fcertbot-2.8.0.tar.gz"
  sha256 "95234695951e458fcc4199b8bc60589d5c7055193265ea0973773b01c5293d4d"
  license "Apache-2.0"
  head "https:github.comcertbotcertbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55a79849514f16ef2387054bcf6353571e89aef75130f6571b2cd1a45e834a79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f523dd775af8500f79975e8a4aea210e33564e7aca79f856d20c37f8bf969450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be48eef66877c7ceab824a66f59a9d64ffeaaa91c266f0535658c724d9b6793"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f487bbd1ff41247e22d0f3b1bb474b4600848c24ead3dd9f042e7624217f259"
    sha256 cellar: :any_skip_relocation, ventura:        "12f659b7401ce73cdac9f08d61d6263ad0d6395717bfa60cf9c949f13a16d7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "41422eca7be819304015297e107b794d49d7a7a63da87069a0139e9c21359815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e746f8b4b57430f683ef7afd58872a62d2ec2588f4d1bae338c587244dc96e01"
  end

  depends_on "augeas"
  depends_on "cffi"
  depends_on "dialog"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackages5bedb9a33ae79229fe0ab5602bf1f871805ac204a383f3986ebdfb750fcc34a9acme-2.8.0.tar.gz"
    sha256 "f1f700ce60d84512fcd19a887f03557fd58e861b3fa061861f90cb90fdbbf208"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackages04b5a3a733a230fc66b3656a0c5183c6c7d2ce449a287626fc293d82f0b486afcertbot-apache-2.8.0.tar.gz"
    sha256 "97516b1b7b59e44eaa3d9f02c3a2d3cf674cf347c22984bd001034d27b0914f1"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackages2498cc27896095a94d99ffb609f07904532b98196bb6554fec41ad4971c8ad91certbot-nginx-2.8.0.tar.gz"
    sha256 "a2c88ce1d9758c356ee96295bf7b5ada8d1df420943fb86e3cb45eb9959ac043"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackages005275ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https:files.pythonhosted.orgpackagesafcc5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.12")
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