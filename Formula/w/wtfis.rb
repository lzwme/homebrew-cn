class Wtfis < Formula
  include Language::Python::Virtualenv

  desc "Passive hostname, domain, and IP lookup tool"
  homepage "https:github.compirxthepilotwtfis"
  url "https:files.pythonhosted.orgpackagesc88ed8005d43adcfd263723de2ee643eb2a6a48e645a9338202c7eda800a0df5wtfis-0.10.0.tar.gz"
  sha256 "1a364350e51d3daca0fba2135207f5eb5234cebd43ac40bda82f7e7b6817bf36"
  license "MIT"
  head "https:github.compirxthepilotwtfis.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abcf19ec42842a51bc1db9eb998e392b3cc94e879f0eb6178a36ee838481bf24"
    sha256 cellar: :any,                 arm64_ventura:  "cb30bee39f84fec2e7b4670b0ccf17a33db173ec7262acbe6543af138c84d45f"
    sha256 cellar: :any,                 arm64_monterey: "d14e9451bb1a212e047bd4d6e9a4b3cae9178ac586ff2467083da825b9d38aff"
    sha256 cellar: :any,                 sonoma:         "21738c049fd5c0bf32021e93c61242c49240a4589aae9fc267d8748381f551a1"
    sha256 cellar: :any,                 ventura:        "7740f6b135a562f5ff11452a332229e3368defc94c0b05e319b9b80dc59eed12"
    sha256 cellar: :any,                 monterey:       "2c1477714a3c59317f961359537b2fc7c0f03e3717a20689d160e24b5be1d136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6fa204497c0f29361ba74357825aa272db2c5bdb23eef68ca8b36a58ff608a"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
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

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages06aef8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897eafilelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
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
    url "https:files.pythonhosted.orgpackages2176a622bd8e7b0b751f65884f54c0430e5910d523b8aeccf11a8bcef26fb17epydantic-2.7.3.tar.gz"
    sha256 "c46c76a40bb1296728d7a8b99aa73dd70a48c3510111ff290034f860c99c419e"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages02d0622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesc506c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackagesdbedc92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagese8fb4217a963512b9646274fe4ce0aebc8ebff09bbb86c458c6163846bb65d9dtyping_extensions-4.12.1.tar.gz"
    sha256 "915f5e35ff76f56588223f15fdd5938f9a1cf9195c0de25130c627e4d597f6d1"
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