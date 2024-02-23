class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https:github.comaws-cloudformationcloudformation-cli"
  url "https:files.pythonhosted.orgpackagesc587fd424990b239f4477b2aebb5815a00b6b156964f2d0ed8668a400589e455cloudformation-cli-0.2.35.tar.gz"
  sha256 "537d1435a22e3d72725a257a3b8d7b1785f7a31973a54c2885cf077303c1204e"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e34269257da3a9a00238810eccd981217f1386f455fc250b739e1434e10a6b31"
    sha256 cellar: :any,                 arm64_ventura:  "65daf517d7daf9d6d3ede4e7501f479f7416b40a26b87fea628a474a7f91b5ae"
    sha256 cellar: :any,                 arm64_monterey: "be74da99931b486b6099f63c0d11baf65db1f5a6225d627cf1845dff0eb63a4c"
    sha256 cellar: :any,                 sonoma:         "6fbff86434d02ca4d583a202a2401df8ae2a71fcf72f36fbb05c53f8dbf79c2d"
    sha256 cellar: :any,                 ventura:        "e4dbf172d582c869d6f01b0c92ec3dc06c20406e916abfb626a4687d679f54d0"
    sha256 cellar: :any,                 monterey:       "726c6960090806b315df1b372665790461539c41a8cc2691c32b9f0d66f3ee05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48ae670720705e140f2e3b7746bde017db16258267d7902c355a843c8ba7ccf"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "go" => :test
  depends_on "libyaml"
  depends_on "python-certifi"
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
    url "https:files.pythonhosted.orgpackages43e02943607c4947d409c55ff4893cb0aabb6759a933c065a201012f80bc63e7aws-sam-translator-1.85.0.tar.gz"
    sha256 "e41938affa128fb5bde5e1989b260bf539a96369bba3faf316ce66651351df39"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages89518b7c07768bef5756cdc38b3168b228139d2ff1ddd782e515f1c0f2c35a2aboto3-1.34.47.tar.gz"
    sha256 "7574afd70c767fdbb19726565a67b47291e1e35ec792c9fbb8ee63cb3f630d45"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages93cf8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https:files.pythonhosted.orgpackagesf1d7c239d3325f40b3323de1da4170a3b2e108fc1094c739cda992619cafe68bcfn-lint-0.85.2.tar.gz"
    sha256 "f8a5cc55daeaaa747b8d776dcf62fe1b6bfb8cb46ae60950cbe627601facccd7"
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
    url "https:files.pythonhosted.orgpackages38c3dd26b7893ee291195564c08b3db44feea4cdbc0f59c8accd51c10855bf3dhypothesis-6.98.10.tar.gz"
    sha256 "b9ab40b13f8941df6a5266f652e62f2ff41bc15ab4cf89fe4864fa5fd06a9bb1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackages056838c6c809fd3203e507c0c95ebede5e682bdc84f2e81fc6f818d7926c6a41jsonpickle-3.0.3.tar.gz"
    sha256 "5691f44495327858ab3a95b9c440a79b41e35421be1a6e09a47b6c9b9421fd06"
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
    url "https:files.pythonhosted.orgpackagesc480a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3canetworkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
    url "https:files.pythonhosted.orgpackages7327a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8fpydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages0d7264550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages5793429cffe6e4b45ef6ef392a30a090a7a431088417fb75f9bc142f4c24f23bpytest-8.0.1.tar.gz"
    sha256 "267f6563751877d772019b13aacbe4e860d73fe8f651f28112e9ac37de7513ae"
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
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
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
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
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
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages0dccff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53dwerkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
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