class CheckJsonschema < Formula
  include Language::Python::Virtualenv

  desc "JSON Schema CLI"
  homepage "https:github.compython-jsonschemacheck-jsonschema"
  url "https:files.pythonhosted.orgpackages1dbbe3d153097528f5672f13c954c658367a0996f84366cbbf511bd3bf1ad755check-jsonschema-0.28.1.tar.gz"
  sha256 "0dbeb24a5c0cfca366906df835131acfeeeff58ce9d6ec7ec3ff7dd4b989d4a1"
  license "Apache-2.0"
  head "https:github.compython-jsonschemacheck-jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9dc22336b5150011829b5d2648bebdfb64fd8a77f74ab73d3cc98ff3a1a920c4"
    sha256 cellar: :any,                 arm64_ventura:  "861ec4058461d91806eb561a47adb2201d8f1dba9f088d94d72c78edc95e4336"
    sha256 cellar: :any,                 arm64_monterey: "e80c3fe014f3e0c2485865a4b1baabae4de5f257c7615b453f0443e2d475e753"
    sha256 cellar: :any,                 sonoma:         "795af934192fdaa45f970f6b66332db0941659e94945723e65aa1b38d8acdf72"
    sha256 cellar: :any,                 ventura:        "3114c24e2cec7aeecc027c33d270ab76b799cef256ccee13610442c9d30c329c"
    sha256 cellar: :any,                 monterey:       "5d8e38951d8216f309b9b6dbe866d0eab25f251f177b63d146911c74e067deb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b303aafd55e40ba45605b7c2abc616d5546e0c13aaec3a39edc02f418f90c2f"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.12"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages59d748b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "regress" do
    url "https:files.pythonhosted.orgpackages113ae9f6af3146dec2ded5149e57797a868e6d4aea1b04d4c9e46e1e0f098514regress-0.4.5.tar.gz"
    sha256 "b42ac506390aea86f3698918889dd6439ca2dca902f3afdc6d70929d144666ef"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages61c5c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackagesa1fbf95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791cwebcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources

    generate_completions_from_executable(
      bin"check-jsonschema",
      shells:                 [:fish, :zsh],
      shell_parameter_format: :click,
    )
  end

  test do
    (testpath"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}check-jsonschema --schemafile #{testpath}test.schema #{testpath}test.json")
    assert_match "ok -- validation done", out
  end
end