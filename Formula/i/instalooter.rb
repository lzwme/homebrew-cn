class Instalooter < Formula
  include Language::Python::Virtualenv

  desc "Download any picture or video associated from an Instagram profile"
  homepage "https:github.comalthonosinstalooter"
  url "https:files.pythonhosted.orgpackages3013907e6aaba6280e1001080ab47e750068ffc5fb7174203985b3c9d678e3f2instalooter-2.4.4.tar.gz"
  sha256 "fb9b4a948702361a161cc42e58857e3a6c9dafd9e22568b07bc0d0b09c3c34a9"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af90107c46d71f357ce20c8587e86087efafadf52e4fcc992067b7516cc940d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af90107c46d71f357ce20c8587e86087efafadf52e4fcc992067b7516cc940d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af90107c46d71f357ce20c8587e86087efafadf52e4fcc992067b7516cc940d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3bd2f8f745932d4f2d9cb1b7e9f49cca12d51e97880b1a0c102bdb94338c18a"
    sha256 cellar: :any_skip_relocation, ventura:        "c3bd2f8f745932d4f2d9cb1b7e9f49cca12d51e97880b1a0c102bdb94338c18a"
    sha256 cellar: :any_skip_relocation, monterey:       "c3bd2f8f745932d4f2d9cb1b7e9f49cca12d51e97880b1a0c102bdb94338c18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ba4a09a7059176d3894b9b92ccd45547358f3a912736aadf1d32c9a20a681c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages5fdd50c569f342bc5d22142e2fc5fab1822d256202f404a384f05541f703f2ffsetuptools-69.3.tar.gz"
    sha256 "e1fd0ca7ba442e4be8a415dcca867b8018777dd5f95f4492bb4dc7d77dbc8bd8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tenacity" do
    url "https:files.pythonhosted.orgpackages700c47136795c8be87c7c30f28c9a56b59deb9550b2a1f5f3abb177daf5da1a3tenacity-6.3.1.tar.gz"
    sha256 "e14d191fb0a309b563904bbc336582efe2037de437e543b38da749769b544d7f"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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