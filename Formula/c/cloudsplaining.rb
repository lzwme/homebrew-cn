class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https:cloudsplaining.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages364110330ab113c1d40a48f32f536579aff5025ea975098f37def13fd7fdaef6cloudsplaining-0.6.2.tar.gz"
  sha256 "02fc4f8482b701b0b19b7ad543b579ba50f31b3e0389bb9f6973391891d6ecd1"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comsalesforcecloudsplaining.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f2c3a4e01e3fd20a4e78e3a00dbe2f321806eca4a218f75f098f2224d298fa5"
    sha256 cellar: :any,                 arm64_ventura:  "db10aad3e5fa734d9470faebe637d6be3fb425e76b55424ace0654c8e4fcb585"
    sha256 cellar: :any,                 arm64_monterey: "d10bef3653c4c28cae3f2a84b1943a1e7201f58f8d407371f94c3336f1538c6e"
    sha256 cellar: :any,                 sonoma:         "16d239eb626eb035b64e1b471c3101fd080ce6576bb9af0d148a98bf92612ab8"
    sha256 cellar: :any,                 ventura:        "bdb6c8852926e6216a0c10d32a55fc41386bf71cbe7c73f9637a7005fe733607"
    sha256 cellar: :any,                 monterey:       "ba497e7ee981a39084a54a64cfb3231d28865c023956c1d7253a371e776fdd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3860c82404a5d1d6ff81bea6554598a348c5ab3a42d13bc0a28f6b151c7cef"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages81f50c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9ec9844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagese7b891054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages22024785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948Markdown-3.6.tar.gz"
    sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "policy-sentry" do
    url "https:files.pythonhosted.orgpackages7e7a7fbb394f21a3c43edcb7d04382b6d93567900b4c8ea4b224b284656115edpolicy_sentry-0.12.11.tar.gz"
    sha256 "8db1ea570e835d87c57ef51bf6f2372a8b78d463549a5f9c65cb5f8103cd1ed8"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cloudsplaining --version")

    output = shell_output("#{bin}cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end