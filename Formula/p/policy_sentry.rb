class PolicySentry < Formula
  include Language::Python::Virtualenv

  desc "Generate locked-down AWS IAM Policies"
  homepage "https:policy-sentry.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages7e7a7fbb394f21a3c43edcb7d04382b6d93567900b4c8ea4b224b284656115edpolicy_sentry-0.12.11.tar.gz"
  sha256 "8db1ea570e835d87c57ef51bf6f2372a8b78d463549a5f9c65cb5f8103cd1ed8"
  license "MIT"
  head "https:github.comsalesforcepolicy_sentry.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21f631042aab62186f61cada3313a6674ccba735f7db27030ab42f0bf445a8bd"
    sha256 cellar: :any,                 arm64_ventura:  "70f3b1d669958f68611b7c95834d596e807cdfe215aafe6b3189f57bcb3be5b9"
    sha256 cellar: :any,                 arm64_monterey: "bbde5aa9f1a69bfa44b225f9a79aeb2354325e193e8160f297481d59c3645f2a"
    sha256 cellar: :any,                 sonoma:         "36622d4dae7c82de5a7c3c43780a3434811ff485e6142508ef8c53810f4c2f22"
    sha256 cellar: :any,                 ventura:        "7abf24ceffe0ce81f2626324e8fb3bf9d7514b7bcee59b8e199756bde58d8b1c"
    sha256 cellar: :any,                 monterey:       "9f8921afed39abac34ee45b96e588af75755c8b0518b209d4df6aa043dff6046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a54428d5cffcb2600c6e126c6271c5a9e98f93f6a0fb63fdad2cb20c717eb7"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "contextlib2" do
    url "https:files.pythonhosted.orgpackagesc71337ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8fcontextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackages4ee801e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}policy_sentry --version")

    system bin"policy_sentry", "initialize"
    assert_predicate testpath".policy_sentryiam-definition.json", :exist?
  end
end