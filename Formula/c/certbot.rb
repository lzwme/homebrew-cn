class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackagesd77e5155b8a7837fb433acee0bfd87e950bab96ab7e02ece21cc9c7d3d5effc4certbot-2.10.0.tar.gz"
  sha256 "892aa57d4db74af174aec5e4bb7f7537b200de2545a066c049d03a53215f0e4e"
  license "Apache-2.0"
  revision 2
  head "https:github.comcertbotcertbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b922c402e9b15a237b1b22e30e9746a9662c84e399206a7647c3ee38ad5d5f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "155c513fa2a9b05259113b91f7f9176177ff30b7ec4daa083619a6840e4dfe01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af31ef8b3a4cdeda296bcab92c9cf46f0cc5c71b841d3871443524107d91b460"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f49384a60bbd0be9cbfe42536ce2b4461509f6cabd9c55d1a37c7c07dac3e4"
    sha256 cellar: :any_skip_relocation, ventura:        "49ea302ea489052a4e2b1153f0cb64a1b5a063382343f0d3399c16091c1b15ad"
    sha256 cellar: :any_skip_relocation, monterey:       "14cea235a3dd2168a5b5bcbdae429674bd23ec1e8b3a1d78ae67b0ba11a1379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c727ac3dcf6a3db64ee56b049348c8dfad6093c1bd1bcaf3f9a13979f1e2fa1"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackagesf1eb7731d7e3c099adaaa814ecf12bd1f6741605b8d80e9b33b69a51849cf280acme-2.10.0.tar.gz"
    sha256 "de110d6550f22094c920ad6022f4b329380a6bd8f58dd671135c6226c3a470cc"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackages0adf9841fa889b4209708004930c9e2c96082ee55ac8bff728b555a3a716ea4ecertbot-apache-2.10.0.tar.gz"
    sha256 "c7a46ff67eac2834a3e3b975e7a1d1bc7a7be889f51c2cdc87825abd5ccc825a"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackages9890a7416a2602889819948a457169c5faa43606a77d25e9e12070cf1a016bbacertbot-nginx-2.10.0.tar.gz"
    sha256 "9add7e8b7005fe6d8405cb74fd868d4b3689a572957a9112d654a5ac1e7f4d91"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackages005275ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https:files.pythonhosted.orgpackagesafcc5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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