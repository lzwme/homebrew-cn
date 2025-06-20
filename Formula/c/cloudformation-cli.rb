class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https:github.comaws-cloudformationcloudformation-cli"
  url "https:files.pythonhosted.orgpackages12ed36f14b63957e99d9f2cbb5ac5671eed9fb93569e57add60534d47fc630e4cloudformation-cli-0.2.39.tar.gz"
  sha256 "63bd83ad0b40b6ad21983dfe05f0717aeaa36cb3f935ef6825f8ca73d7a8e5a7"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c87bef4e76a1272141a9c4751893f2618d6396c569b8663ae1a88cae39a55f60"
    sha256 cellar: :any,                 arm64_sonoma:  "59ed4c86490e61b8082689cfe2d8aea717dc1a030c46bef27c122f4384a9314f"
    sha256 cellar: :any,                 arm64_ventura: "baf4bba06f8902e98becc84dcfe2282b6bb69de6367f99114d4ac2d4ee05c204"
    sha256 cellar: :any,                 sonoma:        "0aab13f8b78a2c3b388879c4e4035e91de5ea54f19d0ab376bc459ff16099aa0"
    sha256 cellar: :any,                 ventura:       "c0137d830d636dc25fd2f3352f15484a6c756e1924bccf35f7689faaa01cc24c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f73d1796d2cd368b4580d4e2155a180ed37e0cb9f7950d297ff28332cd5b935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f2c22c3324876752fd2ddae8cfe4d2186790a495b25f4cdd1be3c1f9202575"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "go" => :test
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackagesa2f8100c32414efc036d6aba7b2591773e9c86f999ab0030850d26e672ed513daws_sam_translator-1.98.0.tar.gz"
    sha256 "fe9fdf51b593aca4cde29f555e272b00d90662315c8078e9f5f3448dd962c66b"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages70b0a35b320e5084821de69a66962513dcc8aa37b7a5bc80e761685533e97be9boto3-1.38.39.tar.gz"
    sha256 "22cca12cfe1b24670de53e3b8f4c69bdf34a2bd3e3363f72393b6b03bb0d78bc"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages096120eceeccdce79ca238453389e9a8a9147a79417a07e22fa6715f1abd6421botocore-1.38.39.tar.gz"
    sha256 "2305f688e9328af473a504197584112f228513e06412038d83205ce8d1456f40"
  end

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https:files.pythonhosted.orgpackagesca4c298568c3192763d8c6ebaef8c76d69d7154c362066a84c9cd4b64dc61c89cfn_lint-1.36.0.tar.gz"
    sha256 "47721fe23755663e69b7d84fec61b1c15fab4e7d8c75ab624e738913bcb59489"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https:files.pythonhosted.orgpackagesbde207731582bdbdeac245da88cfa3154530a26688d14fa4153f49271608c9cacloudformation-cli-go-plugin-2.2.0.tar.gz"
    sha256 "d79ea4341d204cebd4fd290aef847efb84adf33719bf19444ec45208b8c12f14"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https:files.pythonhosted.orgpackages16f1d2a2c9a2c3d6452bf57d6335db969203c0a9834e90877e6652caa2af5e89cloudformation-cli-java-plugin-2.2.3.tar.gz"
    sha256 "787288f69c7c85347ce543bc3bc88db5cdcb1295938b73980c2002412963222b"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https:files.pythonhosted.orgpackagesaef1bd758290777dd9b87b2ffebd9b4271a95188aed0acb9f6bc44af940ccb31cloudformation-cli-python-plugin-2.1.10.tar.gz"
    sha256 "3883751baaa1c6f9778e946e2758f129b7276b9192e21f921fc815b0765961d6"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages919b4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83cedocker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "hypothesis" do
    url "https:files.pythonhosted.orgpackages89d5d0c7b1dd676c45807de5105e62eeea3c5bfb0ffdd1fe10b3efa3fea0f61ehypothesis-6.135.11.tar.gz"
    sha256 "de2881633c06bd96f8fd4f83b4e62a0c060d488dfe2ea61fe1ede0081e2f16af"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesf297ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages363dca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "nested-lookup" do
    url "https:files.pythonhosted.orgpackagesfd427d6a06916aba63124eb30d2ff638cf76054f6aeea529d47f1859c3b5ccaenested-lookup-0.2.25.tar.gz"
    sha256 "6fa832748c90381f2291d850809e32492519ee5f253d6a5acbc29d937eca02e8"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages6c4fccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96anetworkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackagesf9e23e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages00dd4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8cpydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages08ba45911d754e8eba3d5a841a5ce61a65a685ff1798421ac054f85aa8747dfbpytest-8.4.1.tar.gz"
    sha256 "7c67fd69174877359ed9371ec3af8a3d2b04741818c51e5e99cc1742251fa93c"
  end

  resource "pytest-localserver" do
    url "https:files.pythonhosted.orgpackagesec33e77476a3dee691845a052d6a3b75c715c803566fdf744b43080f92c1107apytest_localserver-0.9.0.post0.tar.gz"
    sha256 "8033a36fb382d2bc4850f9acfe2c3fb5654cd5f0d163af6daf47f290db7d5ff0"
  end

  resource "pytest-random-order" do
    url "https:files.pythonhosted.orgpackages93e589654b4354b10e89969a74130f391b017dbdc113ce27f0e8ff9fa23e44e1pytest-random-order-1.1.1.tar.gz"
    sha256 "4472d7d34f1f1c5f3a359c4ffc5c13ed065232f31eca19c8844c1ab406e79080"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages72d1d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackages83d3803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68csympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "types-dataclasses" do
    url "https:files.pythonhosted.orgpackages4b6adec8fbc818b1e716cb2d9424f1ea0f6f3b1443460eb6a70d00d9d8527360types-dataclasses-0.6.6.tar.gz"
    sha256 "4b5a2fcf8e568d5a1974cd69010e320e1af8251177ec968de7b9bb49aa49f7b9"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages9f6983029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71ewerkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      cloudformation java, go, python plugins are installed, but the Go and Java are not bundled with the installation.
    EOS
  end

  test do
    require "expect"
    require "open3"

    Open3.popen2(bin"cfn", "init") do |stdin, stdout, wait_thread|
      stdout.expect "Do you want to develop a new resource(r) or a module(m) or a hook(h)?."
      stdin.write "r\n"
      stdout.expect "What's the name of your resource type?"
      stdin.write "brew::formula::test\n"
      stdout.expect "Select a language for code generation:"
      stdin.write "1\n"
      stdout.expect "Enter the GO Import path"
      stdin.write "example\n"
      stdout.expect "Initialized a new project in"
      wait_thread.join
    end

    rpdk_config = JSON.parse((testpath".rpdk-config").read)
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_path_exists testpath"rpdk.log"
  end
end