class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/d8/65/0a84f55afd6e245519f708f83cd43433bbe26986500cc6bdf6e309fd988e/certbot-2.7.2.tar.gz"
  sha256 "1425de7e41c29fe1734f53fea5b64c3713df0cfc1df1a23a78d7513001457e6e"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7239d4ea6566812d905fc357e99f39c25ebeece355550c0b1c958817e8a0e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd0f0427aae0be607fc0b8ad0552ca0208cb6e88f4a1e5451ec39f58dcc575e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "374bec3409f813882125a50ef5691f9476df5b292573abd72e42ac96822a3313"
    sha256 cellar: :any_skip_relocation, sonoma:         "484239faa75b7ecf4dcf1179364ee57e92bf4f502939a4cb62e250e16e841963"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d2758e706888022d83d6415d9e8c99c53d370a16809b203b0481df87b1eeb3"
    sha256 cellar: :any_skip_relocation, monterey:       "9148866b048d256f53639ced8c44b563e209223f5005fc24244ba136b3bf8c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d581987ea469398f2241e52621863e3efd9447ae514d94aea8932fc4a4910569"
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
    url "https://files.pythonhosted.org/packages/60/95/6261bf7f8794ead92e56b76d4b5e2a237e3b3b9edb0bc9b7fc249e8a24d1/acme-2.7.2.tar.gz"
    sha256 "52bbc5f51f9887f6ee384e1ea7a3802792e31773d661cf5f5904e3d2be5df72d"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/f0/b3/56bd07cbd90480b4959a3a437befc1eae322bf977814eeb5bca48b0abeed/certbot-apache-2.7.2.tar.gz"
    sha256 "365278b9d3dfad7cb822a4544af5f6c81a23418d797609ca51583b2ffda04ff9"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/02/3e/3f8a117def747df711c45e14477c24dd2f6f7d70c5e0b4738b346137667c/certbot-nginx-2.7.2.tar.gz"
    sha256 "c5eb197cebf5b63c860d758bf8e22a713f4f07c1901d8f42a75f7b312073c365"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/f4/be/5c1d9decbd5e9cf97dccd40d13c5657bef936d87da03c9d7aeb67c1b5126/josepy-1.13.0.tar.gz"
    sha256 "8931daf38f8a4c85274a0e8b7cb25addfd8d1f28f9fb8fbed053dd51aec75dc9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.12")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end