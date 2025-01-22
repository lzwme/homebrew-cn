class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https:cyclonedx.org"
  url "https:files.pythonhosted.orgpackages681e78106d309f58e06247c3c2a19dd475f36c5ad7c3b04492dd54c0430dd313cyclonedx_bom-5.1.2.tar.gz"
  sha256 "69cbabd884d1ca0c500d0307c42bdd93b0e42ee302a316fc5e45b5609bd898c7"
  license "Apache-2.0"
  head "https:github.comCycloneDXcyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2becf2f0290f93f2275fa05923c713c3c53aece6b5e982bc7c3e365cace19d9"
    sha256 cellar: :any,                 arm64_sonoma:  "1a2224af96e908514ea47391e6cec5cc1b00546f9aa8b4564b1e385863c4e1ef"
    sha256 cellar: :any,                 arm64_ventura: "23eb0d17469c2f7b83cccde44d7cb1267f3a67d0865b7838f55e3966cbf6fdde"
    sha256 cellar: :any,                 sonoma:        "79c68019d982b27a8226dd68eeb1491eac76d0f878af5345d96b1e3f77a8d65f"
    sha256 cellar: :any,                 ventura:       "a9be60f438140a96ea3dba43f0f3568eefc0f25be6b23605a030fd1bae7104e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70160bd63ad093eb3c84a074addb8709a7dbf0016267659824910ee4a3ba6c8d"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
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
    url "https:files.pythonhosted.orgpackages67a8c735131c5e2a4e778c335b9f2c0500829d947b095e20331c401cfd0b6ef6cyclonedx_python_lib-8.5.0.tar.gz"
    sha256 "35f7a139042e4df17ff414fa228cec83c7e4e493bdec990847357791ca72f3a5"
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
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages746f8709031ea6e0573e6075d24ea34507b0eb32f83f10e1420f2e34606bf0dalicense_expression-30.4.1.tar.gz"
    sha256 "9f02105f9e0fcecba6a85dfbbed7d94ea1c3a70cf23ddbfb5adf3438a6f6fce0"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "packageurl-python" do
    url "https:files.pythonhosted.orgpackages687d0bd319dc94c7956b4d864e87d3dc03739f125ce174671e3128edd566a63epackageurl_python-0.16.0.tar.gz"
    sha256 "69e3bf8a3932fe9c2400f56aaeb9f86911ecee2f9398dbe1b58ec34340be365d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pip-requirements-parser" do
    url "https:files.pythonhosted.orgpackages5e2a63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "py-serializable" do
    url "https:files.pythonhosted.orgpackages16cf6e482507764034d6c41423a19f33fdd59655052fdb2ca4358faa3b0bcfd1py_serializable-1.1.2.tar.gz"
    sha256 "89af30bc319047d4aa0d8708af412f6ce73835e18bacf1a080028bb9e2f42bdb"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8b1a3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2732fd98246df7a0f309b58cae68b10b6b219ef2eb66747f00dfb34422687087referencing-0.36.1.tar.gz"
    sha256 "ca2e6492769e3602957e9b831b94211599d2aade9477f5d44110d2530cf9aade"
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
    url "https:files.pythonhosted.orgpackages0180cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfdrpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesa96047d92293d9bc521cd2301e423a358abfac0ad409b3a1606d8fbae1321961types_python_dateutil-2.9.0.20241206.tar.gz"
    sha256 "18f493414c26ffba692a72369fea7a154c502646301ebfe3d56a04b3767284cb"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackages7b29061ec845fb58521848f3739e466efd8250b4b7b98c1b6c5bf4d40b419b7ewebcolors-24.11.1.tar.gz"
    sha256 "ecb3d768f32202af770477b8b65f318fa4f566c22948673a977b00d589dd80f6"
  end

  def install
    # attrs > hatchling, fix to `ZIP does not support timestamps before 1980` error
    ENV["SOURCE_DATE_EPOCH"] = Time.now.to_i.to_s

    virtualenv_install_with_resources
  end

  test do
    (testpath"requirements.txt").write <<~REQUIREMENTS
      requests==2.31.0
    REQUIREMENTS
    system bin"cyclonedx-py", "requirements", testpath"requirements.txt", "-o", "cyclonedx.json"
    assert_match "pkg:pypirequests@2.31.0", (testpath"cyclonedx.json").read
  end
end