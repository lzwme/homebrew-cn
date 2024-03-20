class OktaAwscli < Formula
  include Language::Python::Virtualenv

  desc "Okta authentication for awscli"
  homepage "https:github.comokta-awscliokta-awscli"
  url "https:files.pythonhosted.orgpackagesed2c153d8ba330660d756fe6373fb4d1c13b99e63675570042de45aedf300bb7okta-awscli-0.5.5.tar.gz"
  sha256 "a8b1277914b992fc24e934edaf1947291723ce386f2191a8952e7c008f2e77fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, monterey:       "0f7cdac5a44696a66529dc440993030f51c23ef82793186b257e69fa20f6d306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "524189bbf0928c0cf7bf3e1c6149c5ccd6c9d0360cc91f1ec77b3c4cc04ca08f"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesc78288ac9072d339d953f5a1d7e15db58a3dea7f3454b328c54fd4b022f06c01boto3-1.34.65.tar.gz"
    sha256 "db97f9c29f1806cf9020679be0dd5ffa2aff2670e28e0e2046f98b979be498a4"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesd185fb6f44cb76936ef8e7da2390fa88d0aec184a790e6d12c62cc1cbe3b870fbotocore-1.34.65.tar.gz"
    sha256 "399a1b1937f7957f0ee2e0df351462b86d44986b795ced980c11eb768b0e61c5"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages8297930be4777f6b08fc7c248d70c2ea8dfb6a75ab4409f89abc47d6cab37d39configparser-6.0.1.tar.gz"
    sha256 "db45513e971e509496b150be31bd67b0e14ab20b78a383b677e4b158e2c682d8"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "validators" do
    url "https:files.pythonhosted.orgpackagesb2682881ac33c2c015160afd9e3994f5e4e2150bc0e6ba4b470eae6c6e7e8641validators-0.23.1.tar.gz"
    sha256 "106d8ca7e4516d0c77e1b7c112723834dbf39e4abdbfca2574ff7cf183db1786"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}okta-awscli 2>&1", 1)
      ERROR - The app-link is missing. Will try to retrieve it from Okta
      ERROR - No profile found. Please define a default profile, or specify a named profile using `--okta-profile`
    EOS
  end
end