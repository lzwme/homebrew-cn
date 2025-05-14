class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https:domainaware.github.iocheckdmarc"
  url "https:files.pythonhosted.orgpackagesf7e6813515c22640d19be3abf40ba6e1c7390b540f11249fe6d928d9ed22577echeckdmarc-5.8.2.tar.gz"
  sha256 "f7775bf19d2841b412e5b954c9f543fc735c83d3a872eb3fb2324e87f0005c92"
  license "Apache-2.0"
  head "https:github.comdomainawarecheckdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e4b05d56b7c8033e7f24df7199c7d9a76e8dfd43cc1eb7316e32ec1b316561c"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https:files.pythonhosted.orgpackagescf8cf834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "pem" do
    url "https:files.pythonhosted.orgpackages058616c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackages42524d2fe190c785fd8930917bb1412b4c1eff11564e835a63495cf946630236publicsuffixlist-1.0.2.20250509.tar.gz"
    sha256 "4fa37440456e71989ee079144ae279068dcb1cc5625d126affcc8bbc012fda5d"
  end

  resource "pyleri" do
    url "https:files.pythonhosted.orgpackages936a4a2a8a05a4945b253d40654149056ae03b9d5747f3c1c423bb93f1e6d13fpyleri-1.4.3.tar.gz"
    sha256 "17ac2a2e934bf1d9432689d558e9787960738d64aa789bc3a6760c2823cb67d2"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages9f26e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "timeout-decorator" do
    url "https:files.pythonhosted.orgpackages80f80802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451betimeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}checkdmarc example.com")
  end
end