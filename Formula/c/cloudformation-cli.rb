class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https:github.comaws-cloudformationcloudformation-cli"
  url "https:files.pythonhosted.orgpackagesa3e078dd797afac3715d25151be5ad7aa54c24e0bcb3110b3b20f6192d43cf08cloudformation-cli-0.2.36.tar.gz"
  sha256 "8b5fd65f7ce4ddc8c89b440921c8c0749612ef0c88710f17d44d675f5728f88a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09a0ac729dd020c8ba9b84fa780d7b8045d4840f3bf381b033a35af368f61610"
    sha256 cellar: :any,                 arm64_ventura:  "efc3ade8b68e2847242d4c16813c65230e4327bdf1d17a978ea79ec278f0ab96"
    sha256 cellar: :any,                 arm64_monterey: "9231dd5425af97fd2a0f5013ac06ad12865955b300082326c70f78ec7431c2a7"
    sha256 cellar: :any,                 sonoma:         "6735137545f8d2e6236632a1f4a0a08d8748bddc635641f97a3bf808c5849a4c"
    sha256 cellar: :any,                 ventura:        "4c8c9ad45a47c0c39337ef86d2a44f9d931c066ae8c7b1ac4e02b4e4a1217bc1"
    sha256 cellar: :any,                 monterey:       "c2793ca613914d71ef11db14e1e9d438b01a886f1fc652c6a59914c2f20adf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c9632713b379ac12d5d81d169854c5d0ca6800bfed28634b78566f11f2c0aa"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "go" => :test
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "expect" => :test

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackagesa5b841fcb7d76ac74dcdfedf34c73b6ce4f75c19e68534806df319531315c47caws-sam-translator-1.87.0.tar.gz"
    sha256 "80f4fb6d53774634b6ea84af5fdfa9ad94a46945bc4ad4ef11c8008540dfa7f8"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages466d8f361c95d4f948dae469a3072cf998f62300ca3bc1a311c1c029a2793313boto3-1.34.83.tar.gz"
    sha256 "9733ce811bd82feab506ad9309e375a79cabe8c6149061971c17754ce8997551"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages0cb86d1ec4802de76d21851784ca2b1d26575f193c31ebd194a196d08dac0d0dbotocore-1.34.83.tar.gz"
    sha256 "0f302aa76283d4df62b4fbb6d3d20115c1a8957fc02171257fc93904d69d5636"
  end

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https:files.pythonhosted.orgpackages42dcc6afb068eddaba2ba462a0c62645484f6b0d0bc77859c16339f1ba8a6718cfn-lint-0.86.2.tar.gz"
    sha256 "c140c814b6a7db048ac881a4f9b7f4e8335afd706f523f3fbf884eb6322f16f9"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https:files.pythonhosted.orgpackagesbde207731582bdbdeac245da88cfa3154530a26688d14fa4153f49271608c9cacloudformation-cli-go-plugin-2.2.0.tar.gz"
    sha256 "d79ea4341d204cebd4fd290aef847efb84adf33719bf19444ec45208b8c12f14"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https:files.pythonhosted.orgpackages1ee66f7b3aea60930b03545dfc5030a8046d18f5f0f1bafcf3c32a7229d0981fcloudformation-cli-java-plugin-2.1.1.tar.gz"
    sha256 "e783370ab32dddcd6257df959c440253a9084208e3ef915ae8edb95fa7875910"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https:files.pythonhosted.orgpackages10d625e80caf4b52f92300adc482c53fa52548cfa68c2896910f5fc50a44b2f0cloudformation-cli-python-plugin-2.1.8.tar.gz"
    sha256 "d0f467fb35e22a7d72c83350f024380d8d2b958e118e632515ce5ce98f4cf46d"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages25147d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bcdocker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "hypothesis" do
    url "https:files.pythonhosted.orgpackages5a30eaf0f26a982bc3b9bdc701b6b289347275beb1ae50aea146cf443c32ce7chypothesis-6.100.1.tar.gz"
    sha256 "ebff09d7fa4f1fb6a855a812baf17e578b4481b7b70ec6d96496210d1a4c6c35"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https:files.pythonhosted.orgpackages1d7f5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https:files.pythonhosted.orgpackages724b8c2df97303521f99a0a2cc9be7373ee175dbc01d4befb653ff7b8d32b442jsonpickle-3.0.4.tar.gz"
    sha256 "a1b14c8d6221cd8f394f2a97e735ea1d7edc927fbd135b26f2f8700657c8c62b"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages363dca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https:files.pythonhosted.orgpackages98afbc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages54c643f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagescdfc70fe71ff78f680d584eba9c55a30092f6ef0b9cf0c75a74bd35a24151a83pydantic-2.7.0.tar.gz"
    sha256 "b5ecdd42262ca2462e2624793551e80911a1e989f462910bb81aef974b4bb383"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages3d28d693aab237fca82da327990a88a983b2b84b890032076ee4a87e18038dbbpydantic_core-2.18.1.tar.gz"
    sha256 "de9d3e8717560eb05e28739d1b35e4eac2e458553a52a301e51352a7ffc86a35"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages30b77d44bbc04c531dcc753056920e0988032e5871ac674b5a84cb979de6e7afpytest-8.1.1.tar.gz"
    sha256 "ac978141a75948948817d360297b7aae0fcb9d6ff6bc9ec6d514b85d5a65c044"
  end

  resource "pytest-localserver" do
    url "https:files.pythonhosted.orgpackagesb2833bc1384f8217e0974212ea2bc3ede35c83619aca9429085035338c453ff2pytest-localserver-0.8.1.tar.gz"
    sha256 "66569c34fef31a5750b16effd1cd1288a7a90b59155d005e7f916accd3dee4f1"
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
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "sarif-om" do
    url "https:files.pythonhosted.orgpackagesbadebbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78csarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackagese5573485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "types-dataclasses" do
    url "https:files.pythonhosted.orgpackages4b6adec8fbc818b1e716cb2d9424f1ea0f6f3b1443460eb6a70d00d9d8527360types-dataclasses-0.6.6.tar.gz"
    sha256 "4b5a2fcf8e568d5a1974cd69010e320e1af8251177ec968de7b9bb49aa49f7b9"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages0f8400f7193d7bd88ced26cd5f868903e431054424610dc7c041bbe87d2a4d66werkzeug-3.0.2.tar.gz"
    sha256 "e39b645a6ac92822588e7b39a692e7828724ceae0b0d702ef96701f90e70128d"
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
    (testpath"test.exp").write <<~EOS
      #!usrbinenv expect -f
      set timeout -1

      spawn #{bin}cfn init

      expect -exact "Do you want to develop a new resource(r) or a module(m) or a hook(h)?."
      send -- "r\r"

      expect -exact "What's the name of your resource type?"
      send -- "brew::formula::test\r"

      expect -exact "Select a language for code generation:"
      send -- "1\r"

      expect -exact "Enter the GO Import path"
      send -- "example\r"

      expect -exact "Initialized a new project in"
      expect eof
    EOS

    system "expect", "-f", "test.exp"

    rpdk_config = JSON.parse(File.read(testpath".rpdk-config"))
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_predicate testpath"rpdk.log", :exist?
  end
end