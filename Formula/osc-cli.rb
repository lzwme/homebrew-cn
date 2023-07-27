class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/02/cd/f1b796f5e7a301f6a3c0b910be07188cbfd329d2758e036d24ef26b4ee96/osc-sdk-1.11.0.tar.gz"
  sha256 "d3b71b326b0698da1b9a503cd511a992fe578375fd01b30bdec0d63d8328af66"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ee0050f6963c119000071249bb9c681cc6c71e8c90a61cf0c40d08e6932c6ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2b486844a381705232fb6bea71a9aa945e5e5b6063544d794b1b7da60db287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f846c7f51aca97f2763e43ef568731ce1695ae8c9738c3f5d6e60096ec3ad007"
    sha256 cellar: :any_skip_relocation, ventura:        "258f8315964c631bb949bd1bdea8e6c53160fe906d890fbf576c769250af5e48"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd34ceb8ed738e7ff9e60484a857aaf971b03cbaea058efbe6a0d03e827b0be"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccc064892b4e525daa08dd20dc97cfb9fa6465e26848866173754941cea27849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c521771b33f7e6fdda860a34eea2a39f7b807415ba2951cb901fcc38359935b"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/94/ed/3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1/fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help which is printed in stderr
    str = shell_output("#{bin}/osc-cli -- --help 2>&1 >/dev/null")
    assert_match "osc-cli SERVICE CALL <flags>", str
    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    assert_match "Missing Access Key for authentication", str

    mkdir testpath/".osc"
    (testpath/".osc/config.json").write <<~EOS
      {
        "default": {
          "access_key": "F4K4T706S9XKGEXAMPLE",
          "secret_key": "E4XJE8EJ98ZEJ18E4J9ZE84J19Q8E1J9S87ZEXAMPLE",
          "host": "outscale.com",
          "https": true,
          "method": "POST",
          "region_name": "eu-west-2"
        }
      }
    EOS

    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end