class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https:scrapy.org"
  url "https:files.pythonhosted.orgpackages687ee76d9116a6260f7fbdc4cf98b7bc4c93926ced2bc2c5e124a852cb66dfeaScrapy-2.11.0.tar.gz"
  sha256 "3cbdedce0c3f0e0482d61be2d7458683be7cd7cf14b0ee6adfbaddb80f5b36a5"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comscrapyscrapy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a20902e19d3e4aae4224c0aa86bdc08cfe5708f53806a1159259605852ad89d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9abe8434fdd52e459b75ae8ba73bb6046e4de3dfc0707601cd061d78df5a706d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "938ca86f46214b7bd2aca9ce6f2c491a4753dbf6e8e35713ec0f5579c45c3614"
    sha256 cellar: :any_skip_relocation, sonoma:         "177f0012fa231afe07b1a47f936ca049da23b2574fe9cf190b0b24497218b264"
    sha256 cellar: :any_skip_relocation, ventura:        "0d75e7393272675a1e5d870bc5f517156999f7fd47b2e5220d6b3d8307eff670"
    sha256 cellar: :any_skip_relocation, monterey:       "406d41b67a1f69bcb3c1d5e156bc86f4521fd74d2101d44df7c792124529da7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01ba58a3da09a8170df4377aa4e8159d7d10e1a479cc6a7bd97ebb93c8004cd"
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
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackages7a7b9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6db3aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768bcharset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
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
    url "https:files.pythonhosted.orgpackages6c9359c180bd2d637ad8ff58bacd3187abdd1af3a76d26d34a2544cec93dbfccfilelock-3.13.0.tar.gz"
    sha256 "63c6052c82a1a24c873a549fbd39a26982e8f35a3016da231ead11a5be9dad44"
  end

  resource "hyperlink" do
    url "https:files.pythonhosted.orgpackages3a511947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412ehyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackages61ef945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89dpyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
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

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackagesed410a06e38f7fb55a3a2abaf998e018ed7d22987c0f1abbbcc1d50e06975b4ftldextract-5.0.1.tar.gz"
    sha256 "ac1c5daa02616e9c2608f5fb6dd93049db03d0cf46c7f6fad46e2850a984f019"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackagesb2cecbb56597127b1d51905b0cddcc3f314cc769769efc5e9a8a67f4617f7bcaTwisted-22.10.0.tar.gz"
    sha256 "32acbd40a94f5f46e7b42c109bfae2b302250945561783a8b7a059048f2d4d31"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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