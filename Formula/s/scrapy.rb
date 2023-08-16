class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/33/c9/1c516d418dc5ad8de725590a2d0cf611e547cadedd121d797f80859dfda4/Scrapy-2.10.0.tar.gz"
  sha256 "4e16a33fc8c03a58bdf4e8d4bdca1f867354eac69ccf573658c7ff34fa0cae39"
  license "BSD-3-Clause"
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd2c410729f078a79dadbd2d9100d150b820f243c0a34ba47724a1950cbf88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5651b0bd01915c16220b1ddd13f9d7588fcffa2fb4382ea51f5a6c2909387663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf1dc109d79e8fb07a4bad108921530e6914a3f32fb03b5a2fe560f2fff79b3"
    sha256 cellar: :any_skip_relocation, ventura:        "92e86b92d0cb27bebe2e16cf12342d91ec8ec2a2ab4a583cbca7889457f969f3"
    sha256 cellar: :any_skip_relocation, monterey:       "d0be50fb695de67ece73af21072a04440742512bcc60886a8f299f60bafe5737"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd35efbfebe93eaf50def8daa8145faab611d6796efaf87867eed3a916acdc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e41ef4548c98765ebd2a40eab2b20e8200af281564bad33eb3aba65a33aa62"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  # For `lxml` resource.
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/a1/1e/c09a9ceec55880fa8801fec1492c922ef1d7d84e7c4768c1cc12e0b950c4/itemadapter-0.8.0.tar.gz"
    sha256 "77758485fb0ac10730d4b131363e37d65cb8db2450bfec7a57c3f3271f4a48a9"
  end

  resource "itemloaders" do
    url "https://files.pythonhosted.org/packages/17/38/07db5e6ebdbe7acec2341fb65603fe4639431aa0133748156368f17a6c8e/itemloaders-1.1.0.tar.gz"
    sha256 "21d81c61da6a08b48e5996288cdf3031c0f92e5d0075920a0242527523e14a48"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/75/2a/824fe02ed04292879b779a8cfc89083a1db3a390b6afc336bcf4baeb9424/parsel-1.8.1.tar.gz"
    sha256 "aff28e68c9b3f1a901db2a4e3f158d8480a38724d7328ee751c1a4e1c1801e39"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/3b/cd/de2f063d94115593bdff20d17f461522c90519fb3f5c46e6b4851e17b94e/Protego-0.2.1.tar.gz"
    sha256 "df666d4304dab774e2dc9feb208bb1ac8d71ea5ceec12f4c99eba30fbd642ff2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydispatcher" do
    url "https://files.pythonhosted.org/packages/21/db/030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19c/PyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/4d/11/94d3a5c1a03fa984b3f793ceecfac4b685ca9fc7a3af03f806dbb973555b/queuelib-1.6.2.tar.gz"
    sha256 "4b207267f2642a8699a1f806045c56eb7ad1a85a10c0e249884580d139c2fcd2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/3b/98/2a46c7414ffc1d06ba67d2c2dd62a207a70cb351028a8cd8c85b3dbd1cf7/service_identity-23.1.0.tar.gz"
    sha256 "ecb33cd96307755041e978ab14f8b14e13b40f1fbd525a4dc78f46d2b986431d"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/80/90/d294a3f69b4143cf56c326064086236bc8157c389497893d940968e6cda2/tldextract-3.4.4.tar.gz"
    sha256 "5fe3210c577463545191d45ad522d3d5e78d55218ce97215e82004dcae1e1234"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/b2/ce/cbb56597127b1d51905b0cddcc3f314cc769769efc5e9a8a67f4617f7bca/Twisted-22.10.0.tar.gz"
    sha256 "32acbd40a94f5f46e7b42c109bfae2b302250945561783a8b7a059048f2d4d31"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/47/79/0c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cb/w3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/7a/62/f0d012151af1e8cc0a6c97db74b78141143425dcdf81bc7960c498e28960/zope.interface-6.0.tar.gz"
    sha256 "aab584725afd10c710b8f1e6e208dbee2d0ad009f57d674cb9d1b3964037275d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrapy version")

    system "#{bin}/scrapy", "startproject", "brewproject"
    cd testpath/"brewproject" do
      system "#{bin}/scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}/scrapy crawl brewspider 2>&1")
    end
  end
end