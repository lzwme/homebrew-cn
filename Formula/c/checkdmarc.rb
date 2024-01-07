class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https:domainaware.github.iocheckdmarc"
  url "https:files.pythonhosted.orgpackagesfb4130f7a96929883e6de380212905e411247c6c3cc562990ba09c198840de1dcheckdmarc-5.2.6.tar.gz"
  sha256 "451c295966444b1ba11ace583c9eab53036c0675dd53d567400bf3014e51c34d"
  license "Apache-2.0"
  head "https:github.comdomainawarecheckdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e01dfa65b5bab301627ac0240f8e314150e6552958f66d11ba01c05a6897a011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f47ddcc4eaa8a0fac26d246c3eae6d86de49e53a828d02d5e43603e50aa653c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005859729c3a83c8d932a893f8ce508a7ec7a4fb911dd7da2f5c91069813a4fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fe77d57313bc9692ea1f96acfd0ae39168c5220ce12939530a39bdf14e054e1"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e083a8cb925e0810592cfe56cacb26052f36e7014ae068aa69946514eca60d"
    sha256 cellar: :any_skip_relocation, monterey:       "9a9e4ae21a3a87ee31956e8bdc9473c8776829948fdf01629de6566f008cc221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1b7b0b6cc1aeeb11743305c26a814d893c6b036557bfd5d222d320c9952a8d3"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackages5dc327cd98b1e3e4548de41f4cfdc9cacab42380f830d6ca38a37be890cffb06publicsuffixlist-0.10.0.20231214.tar.gz"
    sha256 "76a2ed46814f091ea867fb40a6c20c142a437af7aae7ac8eb425ddc464bcb8e1"
  end

  resource "pyleri" do
    url "https:files.pythonhosted.orgpackages0e94fa146d2de46b78237562373a2bb9277d69e4149738a11b69c1f42ca64c33pyleri-1.4.2.tar.gz"
    sha256 "18b92f631567c3c0dc6a9288aa9abc5706a8c1e0bd48d33fea0401eec02f2e63"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "timeout-decorator" do
    url "https:files.pythonhosted.orgpackages80f80802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451betimeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}checkdmarc example.com")
  end
end