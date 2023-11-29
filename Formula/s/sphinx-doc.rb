class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  # TODO: Remove `python-setuptools` dependency when babel has a new release with upstream commit.
  # Ref: https://github.com/python-babel/babel/commit/bf7b2ca3dbb2953166e33d24c1dc800a4f7c97a8
  url "https://files.pythonhosted.org/packages/73/8e/6e51da4b26665b4b92b1944ea18b2d9c825e753e19180cc5bdc818d0ed3b/sphinx-7.2.6.tar.gz"
  sha256 "9a5160e1ea90688d5963ba09a2dcd8bdd526620edbb65c328728f1b2228d5ab5"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2171ba9ede008e512555c413a5e381c120874c257be6d7a359b6034918289afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd2654b3c221c3a8eb60ee6de80f244e257e4b38ab2a0920b839e754e3526cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d5b3c72f428e2ead5e470ebc5ebed8d793277a9602b16741a66a77d681229e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "019a933ef7744730b2893184dbf31dd3cd8e6143d353cbf3ad5607b2b81f8256"
    sha256 cellar: :any_skip_relocation, ventura:        "1521a640ea8f77b09938e50d831936fd8ac4e05baf01804b42a94f1b8d886679"
    sha256 cellar: :any_skip_relocation, monterey:       "d7f2d33fa1d4993009e9846ddb27c6062e93b5ef7186d6762aad2878516b256b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8318354364f8c1c6dd874dba5ceacdbab9892012d9cdb608e02b2ab30e2d92b"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-packaging"
  depends_on "python-requests"
  depends_on "python-setuptools" # for babel
  depends_on "python-tabulate"
  depends_on "python@3.12"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/aa/6c/737d2345d86741eeb594381394016b9c74c1253b4cbe274bb1e7b5e2138e/Babel-2.13.1.tar.gz"
    sha256 "33e0952d7dd6374af8dbf6768cc4ddf3ccfefc244f9986d4074704f2fbd18900"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/5f/ed/5ca4b2e90f4b0781f5fac49cdb2947cf719b6d289eedb67e8b1a63d019e3/numpydoc-1.6.0.tar.gz"
    sha256 "ae7a5380f0a06373c3afe16ccd15bd79bc6b07f2704cbc6f1e7ecc94b4f5fc0d"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/1c/5a/fce19be5d4db26edc853a0c34832b39db7b769b7689da027529767b0aa98/sphinxcontrib_applehelp-1.0.7.tar.gz"
    sha256 "39fdc8d762d33b01a7d8f026a3b7d71563ea3b72787d5f00ad8465bd9d6dfbfa"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/2e/f2/6425b6db37e7c2254ad661c90a871061a078beaddaf9f15a00ba9c3a1529/sphinxcontrib_devhelp-1.0.5.tar.gz"
    sha256 "63b41e0d38207ca40ebbeabcf4d8e51f76c03e78cd61abe118cf4435c73d4212"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/fd/2d/abf5cd4cc1d5cd9842748b15a28295e4c4a927facfa8a0e173bd3f151bc5/sphinxcontrib_htmlhelp-2.0.4.tar.gz"
    sha256 "6c26a118a05b76000738429b724a0568dbde5b72391a688577da08f11891092a"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/4f/a2/53129fc967ac8402d5e4e83e23c959c3f7a07362ec154bdb2e197d8cc270/sphinxcontrib_qthelp-1.0.6.tar.gz"
    sha256 "62b9d1a186ab7f5ee3356d906f648cacb7a6bdb94d201ee7adf26db55092982d"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/5c/41/df4cd017e8234ded544228f60f74fac1fe1c75bdb1e87b33a83c91a10530/sphinxcontrib_serializinghtml-1.1.9.tar.gz"
    sha256 "0c64ff898339e1fac29abd2bf5f11078f3ec413cfe9c046d3120d7ca65530b54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sphinx-quickstart", "-pPorject", "-aAuthor", "-v1.0", "-q", testpath
    system bin/"sphinx-build", testpath, testpath/"build"
    assert_predicate testpath/"build/index.html", :exist?
  end
end