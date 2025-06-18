class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/6d/55/51608eb9c5005b81c62dd6c37f50451d262018caa4001a9f4f9b82033823/weaviate_cli-3.2.0.tar.gz"
  sha256 "2f6476e25e04c2080eee6415dd817dd08a28887a268a5a54dbacbd2684ce60d7"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30ab3e267a837fc91fc4ebbd82ad1ee947ad7b836cec7993bc6a2f42e540e850"
    sha256 cellar: :any,                 arm64_sonoma:  "996a13c61039e8e9b9e4bf2a1f8c1b9fedaf4a0db1f7d86d932b1d9654d4e57f"
    sha256 cellar: :any,                 arm64_ventura: "a599199d45f436dc0136f51b0965f0e9e22a9bc5bd60e245723fdf1370aa9a88"
    sha256 cellar: :any,                 sonoma:        "345e9018e43696441e26b71d9766ee00636c1ac4e0cf40d2322ef8daeee69fc4"
    sha256 cellar: :any,                 ventura:       "00e6f78bb826168910e6ee42890bd7f1cc12c0f9b36c498379ef27d97787b4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ddd952df83fc45e7bd390ec9178dcd916a07d2813d4caa6235bb6cd49ce5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6e39e7465784df8a16d443d849651adb34bc3a9d0a4d0554fc340b0dc5ebb4"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/09/47/df70ecd34fbf86d69833fe4e25bb9ecbaab995c8e49df726dd416f6bb822/authlib-1.3.1.tar.gz"
    sha256 "7ae843f03c06c5c0debd63c9db91f9fda64fa62a42a77419fa15fbb7e7a58917"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/65/f9/66af4019ee952fc84b8fe5b523fceb7f9e631ed8484417b6f1e3092f8290/faker-37.4.0.tar.gz"
    sha256 "7f69d579588c23d5ce671f3fa872654ede0e67047820255f43a4aa1925b89780"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/8e/7b/ca3f561aeecf0c846d15e1b38921a60dffffd5d4113931198fbf455334ee/grpcio-1.73.0.tar.gz"
    sha256 "3af4c30918a7f0d39de500d11255f8d9da4f30e94a2033e70fe2a720e184bd8e"
  end

  resource "grpcio-health-checking" do
    url "https://files.pythonhosted.org/packages/10/a5/22a4204c8f5735f17ca00114df430756e2bf252751d6f27564fc35cbd249/grpcio_health_checking-1.73.0.tar.gz"
    sha256 "b2804751213f0bc4855601567e78e557fa2f57277ab27d7d62f100d9fbbf92b2"
  end

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/0b/62/5f7d3a6d394a7d0cf94abaa93e8224b7cdbc0677bdf2caabd20a62d4f5cb/grpcio_tools-1.73.0.tar.gz"
    sha256 "69e2da77e7d52c7ea3e60047ba7d704d242b55c6c0ffb1a6147ace1b37ce881b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/f3/db/8e12381333aea300890829a0a36bfa738cac95475d88982d538725143fd9/numpy-2.3.0.tar.gz"
    sha256 "581f87f9e9e9db2cba2141400e160e9dd644ee248788d6f90636eeb8fd9260a6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/f3/b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8b/protobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/64/07/91582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639/validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/c2/b7/7b27a1530c0425a6b8fa9bcdf57a60b7f01e74aad6e452edafc221655bb2/weaviate_client-4.15.1.tar.gz"
    sha256 "efa61c43f94eeb5039def03b76c1c4b845e8c17868d92f8e77cdcdfe5a4c611e"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"weaviate-cli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end