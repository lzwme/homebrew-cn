class Wtfis < Formula
  include Language::Python::Virtualenv

  desc "Passive hostname, domain, and IP lookup tool"
  homepage "https:github.compirxthepilotwtfis"
  url "https:files.pythonhosted.orgpackages7a5db760e533acaec19208191888f181f4ba4fee5165e5c947cb7a0019e9da62wtfis-0.9.0.tar.gz"
  sha256 "1ae63dceadc3fc0106cb2ca0d0eede5d901736e904b665012554edb3311a27bd"
  license "MIT"
  head "https:github.compirxthepilotwtfis.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6408eca0be56f2e542d7963cbc965eac4c7f8ca7377d0bf0359bc77ee9cddfe"
    sha256 cellar: :any,                 arm64_ventura:  "2f67eb67d994bb69e849373e59dc4a5bf0d47ad098e0b860bf6c84e253d59e94"
    sha256 cellar: :any,                 arm64_monterey: "881a5131e03edf7a81ca273e34dea23e2f51d2ac354a45f9c26d55c077c63522"
    sha256 cellar: :any,                 sonoma:         "a7eeb506c4f68584adb18bbd0b4ebb4601c342349abcb8fd27e1fccfe6cbbc6a"
    sha256 cellar: :any,                 ventura:        "a4091e731b1567293441661f4f3973c8047e515f3fc1c06b3a7b11b82c1bbd94"
    sha256 cellar: :any,                 monterey:       "188618ede38b78dd322db457c4a8aafcdcec4ce169f2c09f6dbced351789270d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1111a4c4c7f0d9b00a7f7716255162b1a9380f56fcf20051506edf22d5f8af1"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages1107106b00ae62297bb3c89b6fbeb571feaf7cbbf6b2ada0e513d756daafd4cepydantic-2.0.3.tar.gz"
    sha256 "94f13e0dcf139a5125e88283fc999788d894e14ed90cf478bcc2ee50bd4fc630"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages57eaedff47ad42857534f3abcc87472802b3181041f4e4fbeac988a5ecfcffaepydantic_core-2.3.0.tar.gz"
    sha256 "5cfb5ac4e82c47d5dc25b209dd4c3989e284b80109f9e08b33c895080c424b4f"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagese31267d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538feerich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackages91a9693d63433cd3ab659862a05d439f420fae5aee1e1dc9bce03c659122b3f8shodan-1.29.1.tar.gz"
    sha256 "e2af6254e19d2a8fa4e929738be551e25dc7aafc394732e776e7e30fa44ce339"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "xlsxwriter" do
    url "https:files.pythonhosted.orgpackagesa6c3b36fa44a0610a0f65d2e65ba6a262cbe2554b819f1449731971f7c16ea3cXlsxWriter-3.2.0.tar.gz"
    sha256 "9977d0c661a72866a61f9f7a809e25ebbb0fb7036baa3b9fe74afcfca6b3cb8c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Error: Environment variable VT_API_KEY not set", shell_output("#{bin}wtfis 2>&1", 1)
  end
end