class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https:cyclonedx.org"
  url "https:files.pythonhosted.orgpackages7a82a3c098f0567a2a43c71080fc9e54899800f7bcbfee9256b70d1d3bd82653cyclonedx_bom-4.1.3.tar.gz"
  sha256 "711af4ee920e2a0f5403dfd6e034f681c43dd41b8ab7e25109a847e309b9c9d1"
  license "Apache-2.0"
  head "https:github.comCycloneDXcyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e11ae3967421abee37cf1d0a3ef53ccc5351c3659aa6ca552f22d33b808a081"
    sha256 cellar: :any,                 arm64_ventura:  "c120b3433f10e57a71ff3de63aecf5feb027f8f9d1a1bcb59495a9ec05156dde"
    sha256 cellar: :any,                 arm64_monterey: "0970f0d79bf46e6e63563de345876463e75916ca18dd117afb0000843dfda15a"
    sha256 cellar: :any,                 sonoma:         "7c6acc40a97746fda4ae87989dc539b8679b63f98ce197b1173090668d425322"
    sha256 cellar: :any,                 ventura:        "4d2119fc99bf164079cf09900d7cb6d367937fe3c8d670888586d7641f9ef7f5"
    sha256 cellar: :any,                 monterey:       "d8efec71bd24cc1465d3ec82c2b4a0202ff779caed7a3f733f228c3ed964d8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9bb28ea9a2b7abb0d74c41026a943978e8b99777e92e77df0055f6707e0ac45"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "boolean-py" do
    url "https:files.pythonhosted.orgpackagesa2d9b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cyclonedx-python-lib" do
    url "https:files.pythonhosted.orgpackages73c413353dc5b801bcc7ddd36f53725bd389965122fd0fb82d22c69a00f44696cyclonedx_python_lib-6.4.3.tar.gz"
    sha256 "3d9450e500ca6f7cf9625e7bff700599dcca70e4a2180705b61917c59743506e"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fqdn" do
    url "https:files.pythonhosted.orgpackages303ea80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages8b5cdb493282aeb3f05e89b4db45898faddaa339740eaccb752942042410703flicense-expression-30.2.0.tar.gz"
    sha256 "599928edd995c43fc335e0af342076144dc71cb858afa1ed9c1c30c4e81794f5"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "packageurl-python" do
    url "https:files.pythonhosted.orgpackages93d76ab8c91b1ef802d6b5905abe16289e1d84d426976ef0c475aa05f1499501packageurl-python-0.15.0.tar.gz"
    sha256 "f219b2ce6348185a27bd6a72e6fdc9f984e6c9fa157effa7cb93e341c49cdcc2"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pip-requirements-parser" do
    url "https:files.pythonhosted.orgpackages5e2a63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "py-serializable" do
    url "https:files.pythonhosted.orgpackages1515464be3feba255f4ae9202898f450a000f7b4156079e61aebde70f413e2d1py_serializable-1.0.2.tar.gz"
    sha256 "158a98a7ffda067d21f844594ce571d97f36172ba538aee1a93196f8b5888bd8"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages21c5b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9areferencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "rfc3339-validator" do
    url "https:files.pythonhosted.orgpackages28eaa9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbdrfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3987" do
    url "https:files.pythonhosted.orgpackages14bbf1395c4b62f251a1cb503ff884500ebd248eed593f41b469f89caa3547bdrfc3987-1.3.8.tar.gz"
    sha256 "d3c4d257a560d544e9826b38bc81db676890c79ab9d7ac92b39c7a253d5ca733"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesbcf028963c9c77e0e0b0f9dea1f65caf8a9100b09ce9cc4a32d969fe94d73bb9types-python-dateutil-2.9.0.20240315.tar.gz"
    sha256 "c1f6310088eb9585da1b9f811765b989ed2e2cdd4203c1a367e944b666507e4e"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackagesa1fbf95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791cwebcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"requirements.txt").write <<~EOS
      requests==2.31.0
    EOS
    system bin"cyclonedx-py", "requirements", testpath"requirements.txt", "-o", "cyclonedx.json"
    assert_match "pkg:pypirequests@2.31.0", (testpath"cyclonedx.json").read
  end
end