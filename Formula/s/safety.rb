class Safety < Formula
  include Language::Python::Virtualenv

  desc "Checks Python dependencies for known vulnerabilities and suggests remediations"
  homepage "https:safetycli.comproductsafety-cli"
  url "https:files.pythonhosted.orgpackages33aff135abb8d147629e9a27f436db5135314adc864a98b62922b33d6f05c836safety-3.5.2.tar.gz"
  sha256 "ecbb2e76f9574284f2c0e168e71ec92b39018ae9516b3b00f132de57ecaa09cb"
  license "MIT"
  revision 1
  head "https:github.compyupiosafety.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2114f59b289d8fe2b13aa0f471f0d6347d16be40959ea31e65d6a127f177833"
    sha256 cellar: :any,                 arm64_sonoma:  "bb885994626f605de592f48f8165c4400b75262cae32357ead5d4fc5fc5e093a"
    sha256 cellar: :any,                 arm64_ventura: "e789cd397c3306ffb8e4112d9453a9dd539a03303b5ae9f3899bb696e3dab957"
    sha256 cellar: :any,                 sonoma:        "75b352fb42a98c16fde56725fae800d6715e18f4cea1b1b0a155075f488d5266"
    sha256 cellar: :any,                 ventura:       "0819c3fbacd956059e339699005719ea8600d8f61f8d5cedcab687ebade17e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c98f5db9c2be18d20f64fb9d6f259d8fbe7426642d101f7bb179bf18c65b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6077f71360aa94cc9a7a89629ec2a8af3c0e219d9fd37ce6151b6013a2fc694"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "authlib" do
    url "https:files.pythonhosted.orgpackagesa29db1e08d36899c12c8b894a44a5583ee157789f26fc4b176f8e4b6217b56e1authlib-1.6.0.tar.gz"
    sha256 "4367d32031b7af175ad3a323d571dc7257b7099d55978087ceae4a0d88cd3210"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "dparse" do
    url "https:files.pythonhosted.orgpackages29ee96c65e17222b973f0d3d0aa9bad6a59104ca1b0eb5b659c25c2900fccd85dparse-0.6.4.tar.gz"
    sha256 "90b29c39e3edc36c6284c82c4132648eaf28a01863eb3c231c2512196132201a"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "joblib" do
    url "https:files.pythonhosted.orgpackagesdcfe0f5a938c54105553436dbff7a61dc4fed4b1b2c98852f8833beaf4d5968fjoblib-1.5.1.tar.gz"
    sha256 "f4f86e351f39fe3d0d32a9f2c3d8af1ee4cec285aafcb27003dda5205576b444"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages1eff26df5a9f5ac57ccf693a5854916ab47243039d2aa9e0fe5f5a0331e7b74bmarshmallow-4.0.0.tar.gz"
    sha256 "3b6e80aac299a7935cfb97ed01d1854fb90b5079430969af92118ea1b12a8d55"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nltk" do
    url "https:files.pythonhosted.orgpackages3c87db8be88ad32c2d042420b6fd9ffd4a149f9a0d7f0e86b3f543be2eeeedd2nltk-3.9.1.tar.gz"
    sha256 "87d127bd3de4bd89a4f81265e5fa59cb1b199b27440175370f7417d2bc7ae868"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages1f5a07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cbpsutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "safety-schemas" do
    url "https:files.pythonhosted.orgpackages0440e5107b3e456ca4b78d1c0d5bd07be3377e673cc54949b18e5f3aed345067safety_schemas-0.0.14.tar.gz"
    sha256 "49953f7a59e919572be25595a8946f9cbbcd2066fe3e160c9467d9d1d6d7af6a"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tenacity" do
    url "https:files.pythonhosted.orgpackages0ad42b0cd0fe285e14b36db076e78c93766ff1d529d70408bd1d2a5a84f1d929tenacity-9.1.2.tar.gz"
    sha256 "1169d376c297e7de388d18b4481760d478b0e99a777cad3a9c86e556f4b697cb"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagescc180bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesc58c7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"safety --version")

    assert_match "Safety is not authenticated, please first authenticate and try again.",
      shell_output(bin"safety check-updates", 1)
  end
end