class CheckJsonschema < Formula
  include Language::Python::Virtualenv

  desc "JSON Schema CLI"
  homepage "https:github.compython-jsonschemacheck-jsonschema"
  url "https:files.pythonhosted.orgpackages6160de055ac749fd6445e0a1c852ea5fc4726632fa3c19bd040f8e1315b87156check_jsonschema-0.29.3.tar.gz"
  sha256 "3838b6d6da536496516d08a1779e7a11737628f84b444fe95d397b96fc8cc73f"
  license "Apache-2.0"
  head "https:github.compython-jsonschemacheck-jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f799f0c420887d28d0893179639c8b36e1457bbeb5e12cf2e332edf9afbdd26"
    sha256 cellar: :any,                 arm64_sonoma:  "3fa0986167503e9b264ab8e70b9f7f972adff01dddb36ec35bf132cc81b0bf81"
    sha256 cellar: :any,                 arm64_ventura: "abb95fae156dccabf99c514506d8cd237d9d0865e09bd07f68e745b80efa740c"
    sha256 cellar: :any,                 sonoma:        "6e653264fe615ebd01bb3aae37899d37303e19c985a9a6da300a4d5bd8639547"
    sha256 cellar: :any,                 ventura:       "ecb3f04f85cf3653675620b7fa7df4965b9f080dd8e9d744622fefd5b6b3c4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4e975dcb51572671dbb50ddcdb914101f76d27cef90192202bb29da1c55fdb"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.12"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
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
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
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
    url "https:files.pythonhosted.orgpackages167c1df9dc6a391ba465d6ae77d190dc230a693765f567e68071ebe9835a7ecbregress-2024.8.1.tar.gz"
    sha256 "4984db8f752a6fd8d954c3c92c091dae6245409b4f0f97366372d13f12839742"
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
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
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
    url "https:files.pythonhosted.orgpackages3ed99c9ec2d870af7aa9b722ce4fd5890bb55b1d18898df7f1d069cab194bb2atypes-python-dateutil-2.9.0.20240906.tar.gz"
    sha256 "9706c3b68284c25adffc47319ecc7947e5bb86b3773f843c73906fd598bc176e"
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
    url "https:files.pythonhosted.orgpackagesfef853150a5bda7e042840b14f0236e1c0a4819d403658e3d453237983addfacwebcolors-24.8.0.tar.gz"
    sha256 "08b07af286a01bcd30d583a7acadf629583d1f79bfef27dd2c2c5c263817277d"
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