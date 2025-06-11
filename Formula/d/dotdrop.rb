class Dotdrop < Formula
  include Language::Python::Virtualenv

  desc "Save your dotfiles once, deploy them everywhere"
  homepage "https:github.comdeadc0de6dotdrop"
  url "https:files.pythonhosted.orgpackages66a78c8f1d7268bcb0ae3f7e43d8b0da03ad0c1336baabbd4b9ce88a4b1d7b36dotdrop-1.15.0.tar.gz"
  sha256 "7e7b5558a66ac514c3861e0bb31262d5972bc15fc97c1402aef8cccffd0bde61"
  license "GPL-3.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08042de4c0ede1385937c384ac1dc5067625578ae65745918fb7237feca8ec16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71bfc7f0ccd8ed7ce1dc24505318774d419358c327fd0b0bc83fd98a3aa753d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dd6d5567d3c558ca5fe42d9f5e562f89988ef9049026722d13f287f2db7a9a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c364ed720da7502a081e25e938b6d0302560bb5be8279a546c7ecb1de5a5657"
    sha256 cellar: :any_skip_relocation, ventura:       "c31b3366cdf96a7e99502a6b01a7d1605c83adcfbe7b97a773c6a2fc4b9cf133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e937e2842688cbff6b5006a770b2170f1b2bcef9441a5cbe4c297dedc66ed5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04313eb9e1ef4f2470c84515f97c919142e020b7799b2a8ea2ed9b61dfd3f3af"
  end

  depends_on "certifi"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docopt-ng" do
    url "https:files.pythonhosted.orgpackagese4508d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"xxx.conf").write("12345678")
    (testpath"config.yaml").write <<~YAML
      config:
        dotpath: .
      dotfiles:
        f_xxx:
          dst: yyy.conf
          src: xxx.conf
      profiles:
        home:
          dotfiles:
          - f_xxx
    YAML
    system bin"dotdrop", "install", "--profile=home"
    assert_match "12345678", File.read("yyy.conf")
  end
end