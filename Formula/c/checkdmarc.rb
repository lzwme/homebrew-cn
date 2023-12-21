class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https:domainaware.github.iocheckdmarc"
  url "https:files.pythonhosted.orgpackagese0a1e1b018e7828d3ab2c18190cd90185e360db8ec416ff23a40908514f0f3dccheckdmarc-5.0.2.tar.gz"
  sha256 "8ee95f3b246d80fbc16e924c9c8773c0ce46f80c6c52c73938ac57cc297fb362"
  license "Apache-2.0"
  head "https:github.comdomainawarecheckdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "825a1ffeeb7ec152d0a9935cd45317a1ebdba80a4e61808cae50c3980d84c78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52e235afee95699fa61f9b26494c5189efbfe6e4cfc559be5adb8ec61a54f5c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e909306acf869d7a9b0f922f7918cb982ef890a6d9f88ae54e837a5e0d64933d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6881f457cbd92113480fca4bd6c2c08008c7a1eaa439ed898f232a46607b2e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "e78544a078ae48ad5ef5e0ef22eb6b8ab6d94b4ed3711b5da59e1abe0824f0a7"
    sha256 cellar: :any_skip_relocation, monterey:       "be58894e3a61dd562d2bc75ac67bcb0711b9fd1e6d2a1ac64cadea2c9db3844e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f23b2e29e64fc9294bc93f6cf5b7345e03689f78e2f7dcf2d5bd7cd9a7fdbdd"
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