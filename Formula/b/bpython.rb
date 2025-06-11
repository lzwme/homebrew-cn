class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https:bpython-interpreter.org"
  url "https:files.pythonhosted.orgpackagesbaddcc02bf66f342a4673867fdf6c1f9fce90ec1e91e651b21bc4af4890101dabpython-0.25.tar.gz"
  sha256 "c246fc909ef6dcc26e9d8cb4615b0e6b1613f3543d12269b19ffd0782166c65b"
  license "MIT"
  revision 1
  head "https:github.combpythonbpython.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d60da6cf634294cda7f89a9d197be247defda0d7ba77c496a63bf5dacd22432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a98ae347f658f3e58fcbbb30f04979b88825759baad584c43436e792e485c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16cb7d1a3c0d87fba4a1f7ae50ee5fa75354d4d0541d385ef1c5ee8000642a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8907e65b0fe7c9e5dbb6affb9f23be5bba9f83f613b908c269fc109ab5205a"
    sha256 cellar: :any_skip_relocation, ventura:       "6e1dcdc560f76f6b0ec201364bc18dce2a20db4aaa6685c019cb81cfb21a4bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec77b4e9f45e004fbac154adfeda3e88fe968101e598ae2aea1b5a74f4a8ec21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b637086839e8ef3b5e8f289854a3ca524029a1c426ff74d7053af65b34cf3cb5"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "blessed" do
    url "https:files.pythonhosted.orgpackages0c5e3cada2f7514ee2a76bb8168c71f9b65d056840ebb711962e1ec08eeaa7b0blessed-1.21.0.tar.gz"
    sha256 "ece8bbc4758ab9176452f4e3a719d70088eb5739798cd5582c9e05f2a28337ec"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "curtsies" do
    url "https:files.pythonhosted.orgpackagesd1185741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https:files.pythonhosted.orgpackages237603fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackagesc992bb85bd6e80148a4d2e0c59f7c0c2891029f8fd510183afc7d8d2feeed9b6greenlet-3.2.3.tar.gz"
    sha256 "8b0dd8ae4c0d6f5e54ee55ba935eeb3d735a9b58a8a1e5b5cbab64e01a39f365"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def python3
    which("python3.13")
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}bpython test.py")
  end
end