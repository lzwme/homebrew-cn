class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/82/d7/c057c62f3cdd8d1baee6ed239ea8f97f738cbab3c5ef46144a7888e679e3/cloudformation-cli-0.2.34.tar.gz"
  sha256 "ef64731ef554f37c9b91a48b3ba605a4b9a77d7c63297cbe54492d1e42fcf164"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dc2411e8abcb8aa00120998612cf3d469a4a8749004a4e12bda8830d6501fb5"
    sha256 cellar: :any,                 arm64_ventura:  "a50f296f144f0d4af3c99edb45ebee6fffb9cd61e17e8511188d934659d761e1"
    sha256 cellar: :any,                 arm64_monterey: "47859adf6211387ccb43da3e68d4c0e2dd5720808ecd2c5f6b62ac403b022a17"
    sha256 cellar: :any,                 sonoma:         "0e9ee4fc830c6272ba9828af6e6907cd670443e3c9193964e3c7101d8e9c98ee"
    sha256 cellar: :any,                 ventura:        "a56475bf84e80cbb29316138499d193b108d794c68f5fd09f1b8279cfefe7cf4"
    sha256 cellar: :any,                 monterey:       "6f77141dae951abef83550923319b723f9152136eb258e8cc0aaee1cc68ef62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b3000690f3d983d1254c3d11d09c32192b4bf91727076d027bb5fc4b96f18d"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "go" => :test
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/79/3d/7168d757744fc624115a9fbfd9a8b387bf94db6077a1f831c2792d84b8b2/aws-sam-translator-1.79.0.tar.gz"
    sha256 "990f3043d00b6fd801b38ad780ecd058c315b7581b2e43fc013c9b6253f876e8"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/dc/ce/8ea68ec13ae68415edd396adeffa4ba972c5b6b2f802ce49cc476afd9dcb/boto3-1.28.71.tar.gz"
    sha256 "8d1b50127b20b817fdcec3ce6a625c5057b5a722acf1cfa64cf3824ff40b1e75"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/23/74/9704da8ef9e8e79097a146f742a114158516f205d840bdfc8711e4c3e53d/botocore-1.31.71.tar.gz"
    sha256 "223e95e8d44ffd85d6baa5c9fc67b029ff087484d304a4478c4dfe38bd433f3f"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/36/09/83e52f94ce347c6c7a6d476bacad76bb9e0dd68d4d30d19e13e45db49289/cfn-lint-0.83.0.tar.gz"
    sha256 "212251e17322c630506ff02117ff53586037bec3a7161f7cb081c7afde9fd2ca"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/8f/00/909410b531a330f3f8a784862dd0daf12541a99a969555e2b3c7af892ec7/cloudformation-cli-go-plugin-2.0.4.tar.gz"
    sha256 "2b6bc4eaa89b7c055a91b86ec957ef765b0c8a43f5af3c4fa916e2d4d3fd03d6"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/f4/0c/bdb0cc836e8380325643847ceb5f06ca45be397785d147987c511d435196/cloudformation-cli-java-plugin-2.0.18.tar.gz"
    sha256 "d5701d8ca9017316b90aed9da57d3195b8578845c7ed0984ed768adf4fef5dca"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https://files.pythonhosted.org/packages/10/d6/25e80caf4b52f92300adc482c53fa52548cfa68c2896910f5fc50a44b2f0/cloudformation-cli-python-plugin-2.1.8.tar.gz"
    sha256 "d0f467fb35e22a7d72c83350f024380d8d2b958e118e632515ce5ce98f4cf46d"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/24/2f/9762d5b9901938ffe7ddfe3527054f6aa4d5335b1595150623f4abab76e7/hypothesis-6.88.1.tar.gz"
    sha256 "f4c2c004b9ec3e0e25332ad2cb6b91eba477a855557a7b5c6e79068809ff8b51"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "nested-lookup" do
    url "https://files.pythonhosted.org/packages/fd/42/7d6a06916aba63124eb30d2ff638cf76054f6aeea529d47f1859c3b5ccae/nested-lookup-0.2.25.tar.gz"
    sha256 "6fa832748c90381f2291d850809e32492519ee5f253d6a5acbc29d937eca02e8"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/86/36/f9367f30c63a9e10f387783dc18b2e0454dc9debb25151b7a6d592590375/networkx-3.2.tar.gz"
    sha256 "bda29edf392d9bfa5602034c767d28549214ec45f620081f0b74dc036a1fbbc1"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/38/d4/174f020da50c5afe9f5963ad0fc5b56a4287e3586e3de5b3c8bce9c547b4/pytest-7.4.3.tar.gz"
    sha256 "d989d136982de4e3b29dabcc838ad581c64e8ed52c11fbe86ddebd9da0818cd5"
  end

  resource "pytest-localserver" do
    url "https://files.pythonhosted.org/packages/b2/83/3bc1384f8217e0974212ea2bc3ede35c83619aca9429085035338c453ff2/pytest-localserver-0.8.1.tar.gz"
    sha256 "66569c34fef31a5750b16effd1cd1288a7a90b59155d005e7f916accd3dee4f1"
  end

  resource "pytest-random-order" do
    url "https://files.pythonhosted.org/packages/3d/ef/93dc9fa0b3b7eb99566813bccaf50216ef1c7d8d07923348fabbd6f7eefc/pytest-random-order-1.1.0.tar.gz"
    sha256 "dbe6debb9353a7af984cc9eddbeb3577dd4dbbcc1529a79e3d21f68ed9b45605"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "types-dataclasses" do
    url "https://files.pythonhosted.org/packages/4b/6a/dec8fbc818b1e716cb2d9424f1ea0f6f3b1443460eb6a70d00d9d8527360/types-dataclasses-0.6.6.tar.gz"
    sha256 "4b5a2fcf8e568d5a1974cd69010e320e1af8251177ec968de7b9bb49aa49f7b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/cfn"
  end

  def caveats
    <<~EOS
      cloudformation java, go, python plugins are installed, but the Go and Java are not bundled with the installation.
    EOS
  end

  test do
    (testpath/"test.exp").write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/cfn init

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

    rpdk_config = JSON.parse(File.read(testpath/".rpdk-config"))
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_predicate testpath/"rpdk.log", :exist?
  end
end