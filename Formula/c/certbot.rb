class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackagesfebf3ed9a042683141c4b3b53be492db5d2e7553ba59d0b8fb34cad2938df9b9certbot-3.2.0.tar.gz"
  sha256 "2939a248def1a8bce661f8d92f9add975108741d7d96fcbfff2936031e72930c"
  license "Apache-2.0"
  head "https:github.comcertbotcertbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ca1247da5e0f5696d20001526d0c8e21574f4b447f97f79976c0c37f982ee0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca1247da5e0f5696d20001526d0c8e21574f4b447f97f79976c0c37f982ee0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ca1247da5e0f5696d20001526d0c8e21574f4b447f97f79976c0c37f982ee0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3842b6e843b65f099815a4504afd2bfd929066216ddc5c59ae7bb4e9694905a3"
    sha256 cellar: :any_skip_relocation, ventura:       "3842b6e843b65f099815a4504afd2bfd929066216ddc5c59ae7bb4e9694905a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca1247da5e0f5696d20001526d0c8e21574f4b447f97f79976c0c37f982ee0e"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackagesf96ac94be0e8ee157f3c7721844863589c627c40bfa10d8838faeb6b28b59bb2acme-3.2.0.tar.gz"
    sha256 "e11d0ccf43ec19244ada40df1dc4ca49c9ce407749f3771d2cefe0674e206d84"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackages4f90e8198c6474d5ce8a2f1302837de1cf6cbd034ba3342be4088b68791fba74certbot_apache-3.2.0.tar.gz"
    sha256 "f453c09c8dc26ddbb70a191ec4b8953171dcbfbeb66cd8a9d83cd9420d61d195"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackagesc41da087ae9e6bc80f03d2e200fc222d5682353dd75faf276df7a829407eb4c2certbot_nginx-3.2.0.tar.gz"
    sha256 "90d75ecb3da76e0aa063fbf73dee92558da2447da48ada6fa9d13cb18bffc272"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https:files.pythonhosted.orgpackagesc18acd416f56cd4492878e8d62701b4ad32407c5ce541f247abf31d6e5f3b79bjosepy-1.15.0.tar.gz"
    sha256 "46c9b13d1a5104ffbfa5853e555805c915dcde71c2cd91ce5386e84211281223"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages9f26e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8b1a3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
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
    url "https:files.pythonhosted.orgpackages5f57df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8apytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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