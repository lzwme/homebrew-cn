class Instalooter < Formula
  include Language::Python::Virtualenv

  desc "Download any picture or video associated from an Instagram profile"
  homepage "https:github.comalthonosinstalooter"
  url "https:files.pythonhosted.orgpackages3013907e6aaba6280e1001080ab47e750068ffc5fb7174203985b3c9d678e3f2instalooter-2.4.4.tar.gz"
  sha256 "fb9b4a948702361a161cc42e58857e3a6c9dafd9e22568b07bc0d0b09c3c34a9"
  license "GPL-3.0-or-later"
  revision 11

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94426ba0b3b5a40609a0f9473fe0b0382cb4dfe97acccdd637563ec3e993134f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94426ba0b3b5a40609a0f9473fe0b0382cb4dfe97acccdd637563ec3e993134f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94426ba0b3b5a40609a0f9473fe0b0382cb4dfe97acccdd637563ec3e993134f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d00ae9f509773e37ccd8d5c2b5d721bcd63dc8cd6ed824e875be45e7d86b5c9"
    sha256 cellar: :any_skip_relocation, ventura:       "4d00ae9f509773e37ccd8d5c2b5d721bcd63dc8cd6ed824e875be45e7d86b5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6279654d6f601a86decff3bf38565a14e52d2a94457139466634ec0aa20d0ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6279654d6f601a86decff3bf38565a14e52d2a94457139466634ec0aa20d0ede"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "coloredlogs" do
    url "https:files.pythonhosted.orgpackages5a6d1796dc260bfd8be7c9ecd9c17e02b5b2ad9ba310983cc4ceabc1ea4dbb42coloredlogs-14.3.tar.gz"
    sha256 "7ef1a7219870c7f02c218a2f2877ce68f2f8e087bb3a55bd6fbaa2a4362b4d52"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "fs" do
    url "https:files.pythonhosted.orgpackages5da9af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tenacity" do
    url "https:files.pythonhosted.orgpackages700c47136795c8be87c7c30f28c9a56b59deb9550b2a1f5f3abb177daf5da1a3tenacity-6.3.1.tar.gz"
    sha256 "e14d191fb0a309b563904bbc336582efe2037de437e543b38da749769b544d7f"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "verboselogs" do
    url "https:files.pythonhosted.orgpackages291590ffe9bdfdd1e102bc6c21b1eea755d34e69772074b6e706cab741b9b698verboselogs-1.7.tar.gz"
    sha256 "e33ddedcdfdafcb3a174701150430b11b46ceb64c2a9a26198c76a156568e427"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"instalooter", "logout"
  end
end