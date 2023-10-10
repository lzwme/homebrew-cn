class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/db/14/2e16620742e5d56eb6035c0bbf16ae04a8dee50d67d09d8df4e196d53184/shodan-1.30.0.tar.gz"
  sha256 "c9617c66c47b87d4801e7080b6c769ec9a31da398defe0b047a6794927436453"
  license "MIT"
  revision 1
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bceb629ccdbce063f49edf5e9edbf77a98283bec996ab722e53eb9fc692a775"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b72af651d2d5a9da846197a30cb9594002b294da76698e2210a11f0d5997185c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3703c32e232aae79a4d717dfc407a66047481e4fe44159478adbcc38b1102966"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca18abe7e0ac341beb7733cae620b02b6030461dbc6f10457f15c7d3c9a85070"
    sha256 cellar: :any_skip_relocation, ventura:        "2d7ddf7a2def2ff16a11129fd4b8b9ee30687c9fffe4ff66cd9bcca7cc1019b6"
    sha256 cellar: :any_skip_relocation, monterey:       "4eea69d3128e192c8e58ed84f49049f4fe030570c0581414341da133573b1f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62124a2c168727b63895bb8102381f9655527d6ee6e31804c164046471fd3b7f"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ba/7a/dc3ffc0e333d33e8ccb63a14adc40180c29d89490a25ebe9f9ef01605c51/tldextract-3.6.0.tar.gz"
    sha256 "a5d8b6583791daca268a7592ebcf764152fa49617983c49916ee9de99b366222"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/5c/77/956e6ab727d9e9ba29a718e172158814f7ded1670219e4366b8851fedc11/XlsxWriter-3.1.7.tar.gz"
    sha256 "353042efb0f8551ce72baa087e98228f3394fcb380e8b96313edf1eec8d50823"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end