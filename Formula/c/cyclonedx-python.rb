class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https:cyclonedx.org"
  url "https:files.pythonhosted.orgpackagese24117e41656364123a68aeb048aae10cb8642180f60e03b3d0fa576c80e9133cyclonedx_bom-4.1.2.tar.gz"
  sha256 "c64c54b18f0ecd67f90895a812cd8411e56d5c0130e5dd26a5a6b8cb3a9d7581"
  license "Apache-2.0"
  head "https:github.comCycloneDXcyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "373a0b901736693046b5bffb7cb218962d4705447b229af12b988811d194d0e5"
    sha256 cellar: :any,                 arm64_ventura:  "f29034732b0ae72477f1e72e155ceffb88449d9a5b34f14793f3e907e0db22cb"
    sha256 cellar: :any,                 arm64_monterey: "0bf6a0c073363780a5c950e29f485c7c2fadd0f838efa649c895e0d9677bd12d"
    sha256 cellar: :any,                 sonoma:         "5711e5fa2c05c7f7a8b64b6e2b6b8f528ba2e0437ac1330be37b89bd872c7980"
    sha256 cellar: :any,                 ventura:        "83d7cc43123adc34a6f8723ec06aa96411d90312d58c848bf6cc60b617cffe49"
    sha256 cellar: :any,                 monterey:       "42ba9206c840c1b2dc3a4771236676e1c6d3af4efcc59917b854eb747b8380b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb17d8b84f3d027001427269e26e3a25192686462ea612c8b3d4223d9cd4bf2"
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
    url "https:files.pythonhosted.orgpackages4a085a2f8504df02bee23ecb5a6aaeaae91506cbb082ca580b60687e635155cccyclonedx_python_lib-6.4.2.tar.gz"
    sha256 "b857972c6a7317faa66ec4ed4b6040dae7fca82e40eddfbeaa7f0f37f9a7cac7"
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
    url "https:files.pythonhosted.orgpackages6924d8542499ca412df95ce8f3722f8be504161ae0a3ad5fa0d159522356e6edpackageurl-python-0.14.0.tar.gz"
    sha256 "ff09147cddaae9e5c59ffcb12df8ec0e1b774b45099399f28c36b1a3dfdf52e2"
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
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackagesd977bd458a2e387e98f71de86dcc2ca2cab64489736004c80bc12b70da8b5488python-dateutil-2.9.0.tar.gz"
    sha256 "78e73e19c63f5b20ffa567001531680d939dc042bf7850431877645523c66709"
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
    url "https:files.pythonhosted.orgpackages9b472a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
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