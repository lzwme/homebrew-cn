class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https:inquest.readthedocs.ioprojectsiocextractenlatest"
  url "https:files.pythonhosted.orgpackagesad4b19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 7
  head "https:github.comInQuestiocextract.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e966846d98d6ed172406aef7361d6133a6294e8a85ba9e208439a6b20324fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24264d9de289813a4ff0ba5f2c13a627406865c6a132cd32299c2f9ff926bab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb402c4aab73475a1b010a7c79afba3a072bd64673c95e577cdfae06741e8ac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "24fb0c25b6e82a36ffc21f8cfbdd808d9edb77b3c732f8901e3af963b9a8abd1"
    sha256 cellar: :any_skip_relocation, ventura:       "10ad09f738cc9a67c86bc2bd24457676292ead6073a1013407793e4f55910026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f0b19b12d2dae8bec0f80bd5b0d597c68ba4eea0acad10b2e0c0d228d7c5b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ad5406107eceaf48f7a92b5125b0a631ee2e63fc0e33f693f03d30778a3e8ef"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 632017 and cdnverify[.]net since 2118.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}iocextract -i #{testpath}test.txt")
  end
end