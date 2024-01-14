class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https:scrapy.org"
  url "https:files.pythonhosted.orgpackages687ee76d9116a6260f7fbdc4cf98b7bc4c93926ced2bc2c5e124a852cb66dfeaScrapy-2.11.0.tar.gz"
  sha256 "3cbdedce0c3f0e0482d61be2d7458683be7cd7cf14b0ee6adfbaddb80f5b36a5"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comscrapyscrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26adf706307abd6b558c906695dc5d9ef36c1b156c741020152e58fe5c74b0be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6b15e4dbe9cd646a03909a4caa78a701a57c33d75138c35afeb46a628c8654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85eb938027084f7b02f8e99f0ebaadc4e7dadbb85e0b873a546a3f0da66636c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "75af8680083008afbb0f790dd9fcdb62dcbf74d6ee9d94cad0838098a460aa77"
    sha256 cellar: :any_skip_relocation, ventura:        "12e2d54c3d0ddf33bf6cd8f93a2ca99a0f6fd0659fd717d0a54d1596741031c6"
    sha256 cellar: :any_skip_relocation, monterey:       "faf45adcbace3f4546dbfdd5c8cfe7f2339ae01e1c467a7a364efec84ae42e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f172025487ec49d5da3d455ffff00f8ec4ec68e8767e0b13c647ffcf7854bb7"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackages7a7b9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "hyperlink" do
    url "https:files.pythonhosted.orgpackages3a511947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412ehyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "incremental" do
    url "https:files.pythonhosted.orgpackages86429e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "itemadapter" do
    url "https:files.pythonhosted.orgpackagesa11ec09a9ceec55880fa8801fec1492c922ef1d7d84e7c4768c1cc12e0b950c4itemadapter-0.8.0.tar.gz"
    sha256 "77758485fb0ac10730d4b131363e37d65cb8db2450bfec7a57c3f3271f4a48a9"
  end

  resource "itemloaders" do
    url "https:files.pythonhosted.orgpackages173807db5e6ebdbe7acec2341fb65603fe4639431aa0133748156368f17a6c8eitemloaders-1.1.0.tar.gz"
    sha256 "21d81c61da6a08b48e5996288cdf3031c0f92e5d0075920a0242527523e14a48"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "parsel" do
    url "https:files.pythonhosted.orgpackages752a824fe02ed04292879b779a8cfc89083a1db3a390b6afc336bcf4baeb9424parsel-1.8.1.tar.gz"
    sha256 "aff28e68c9b3f1a901db2a4e3f158d8480a38724d7328ee751c1a4e1c1801e39"
  end

  resource "protego" do
    url "https:files.pythonhosted.orgpackages2c7efc128cfd3bb8e081165fcdaad44ab5fff73678fbebc51f79f733c57c5295Protego-0.3.0.tar.gz"
    sha256 "04228bffde4c6bcba31cf6529ba2cfd6e1b70808fdc1d2cb4301be6b28d6c568"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydispatcher" do
    url "https:files.pythonhosted.orgpackages21db030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19cPyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "queuelib" do
    url "https:files.pythonhosted.orgpackages4d1194d3a5c1a03fa984b3f793ceecfac4b685ca9fc7a3af03f806dbb973555bqueuelib-1.6.2.tar.gz"
    sha256 "4b207267f2642a8699a1f806045c56eb7ad1a85a10c0e249884580d139c2fcd2"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages505cd32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "service-identity" do
    url "https:files.pythonhosted.orgpackages3b982a46c7414ffc1d06ba67d2c2dd62a207a70cb351028a8cd8c85b3dbd1cf7service_identity-23.1.0.tar.gz"
    sha256 "ecb33cd96307755041e978ab14f8b14e13b40f1fbd525a4dc78f46d2b986431d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages02214f2d7d6023650770112dd8144dbc47afabbfaf568a0d39abc0a4f37e8e9etldextract-5.1.1.tar.gz"
    sha256 "9b6dbf803cb5636397f0203d48541c0da8ba53babaf0e8a6feda2d88746813d4"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackagesb2cecbb56597127b1d51905b0cddcc3f314cc769769efc5e9a8a67f4617f7bcaTwisted-22.10.0.tar.gz"
    sha256 "32acbd40a94f5f46e7b42c109bfae2b302250945561783a8b7a059048f2d4d31"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackages47790c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cbw3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackages87036b85c1df2dca1b9acca38b423d1e226d8ffdf30ebd78bcb398c511de8b54zope.interface-6.1.tar.gz"
    sha256 "2fdc7ccbd6eb6b7df5353012fbed6c3c5d04ceaca0038f75e601060e95345309"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}scrapy version")

    system "#{bin}scrapy", "startproject", "brewproject"
    cd testpath"brewproject" do
      system "#{bin}scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}scrapy crawl brewspider 2>&1")
    end
  end
end