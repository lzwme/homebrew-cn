class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/73/8e/6e51da4b26665b4b92b1944ea18b2d9c825e753e19180cc5bdc818d0ed3b/sphinx-7.2.6.tar.gz"
  sha256 "9a5160e1ea90688d5963ba09a2dcd8bdd526620edbb65c328728f1b2228d5ab5"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ed46836d8bd431e857260ab63e908287b0b3808052d163dd71d31abe6e150b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b3922dc6db12ae2a90bb73e9c3fd5811d82e57b29ac2c828d0910140e5349b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea26b16679d758a275ab77d832703180e9265ad2f588f8bb52683a9cd80e1ca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0dd50069087500229793885b7c4a32a7f9fb6aff83813a08d0f5fb96682cc33"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa5c96d631f58736fb8ea5f1689629cc216fbcbd21fc0a838ba4a2269ff7b88"
    sha256 cellar: :any_skip_relocation, monterey:       "7de450cd16c32fbf85724cb1deba30b44f887539f49e497f4a5a21cdafff1da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041966d36261bde513a9cbd4661c347c31265a97d87c45b67de2aa12bae300a1"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python@3.12"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/d5/7d/08e7b8b1ab446121ace3de332f144be41a52049a23303375a0126d515cb7/Babel-2.13.0.tar.gz"
    sha256 "04c3e2d28d2b7681644508f836be388ae49e0cfe91465095340395b60d00f210"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/5f/ed/5ca4b2e90f4b0781f5fac49cdb2947cf719b6d289eedb67e8b1a63d019e3/numpydoc-1.6.0.tar.gz"
    sha256 "ae7a5380f0a06373c3afe16ccd15bd79bc6b07f2704cbc6f1e7ecc94b4f5fc0d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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