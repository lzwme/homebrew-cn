class CheckJsonschema < Formula
  include Language::Python::Virtualenv

  desc "JSON Schema CLI"
  homepage "https:github.compython-jsonschemacheck-jsonschema"
  url "https:files.pythonhosted.orgpackages845207a76a51fba27592c2b24ebc0426e1bb84af77220c89deed2e03fd67f40ccheck_jsonschema-0.30.0.tar.gz"
  sha256 "c912ef9cf204c17d2e9d832b9088040f1c0c3f178ebda9805a56e5f35b29f5f2"
  license "Apache-2.0"
  head "https:github.compython-jsonschemacheck-jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87baa419eaf12ff91449aa59cb14545455f82d24452c432bcde896a62ca21949"
    sha256 cellar: :any,                 arm64_sonoma:  "eb00a802d5475e1fb0895f43cce4379b62a932868cf366fd2e7a6256d90fa3d2"
    sha256 cellar: :any,                 arm64_ventura: "52795724dfa5fa3433c1ee8d4fcdd8a266185964da9e069d69fcf7b958c1964a"
    sha256 cellar: :any,                 sonoma:        "3ce81ee60a11cc8f2760e8ffbfdb458d8f5a1305db3c9de61bd67dd71f1308e8"
    sha256 cellar: :any,                 ventura:       "3763c1e3edeaf7430b6b0c84e313f1e9a2f60aeca8bbbf41db397a094df74c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779f10e89152a68d1827b5561a7d3208114959ca25aea5a4f3a24e701fced176"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regress" do
    url "https:files.pythonhosted.orgpackages6a6648fe4e8d5b14f9d5ac394b4f8847c1cf69f8c1cfa4c2b216f570f0114f97regress-2024.11.1.tar.gz"
    sha256 "f029ac1c6fe6facdc99700b0169cfe5fb0bd7e5e373a1299fe5084af6982b983"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages31f8f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16etypes-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackages7b29061ec845fb58521848f3739e466efd8250b4b7b98c1b6c5bf4d40b419b7ewebcolors-24.11.1.tar.gz"
    sha256 "ecb3d768f32202af770477b8b65f318fa4f566c22948673a977b00d589dd80f6"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      bin"check-jsonschema",
      shells:                 [:fish, :zsh],
      shell_parameter_format: :click,
    )
  end

  test do
    (testpath"test.json").write <<~JSON
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    JSON

    (testpath"test.schema").write <<~JSON
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    JSON

    out = shell_output("#{bin}check-jsonschema --schemafile #{testpath}test.schema #{testpath}test.json")
    assert_match "ok -- validation done", out
  end
end