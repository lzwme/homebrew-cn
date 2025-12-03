class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/12/ed/36f14b63957e99d9f2cbb5ac5671eed9fb93569e57add60534d47fc630e4/cloudformation-cli-0.2.39.tar.gz"
  sha256 "63bd83ad0b40b6ad21983dfe05f0717aeaa36cb3f935ef6825f8ca73d7a8e5a7"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23bf387424737e1061be416d1657ec5ed10dc74550aa6bb93f4aceae88c33983"
    sha256 cellar: :any,                 arm64_sequoia: "157cfff5eadcc5deb660fc587b69907d111cfa8518064db823a71e10ce1bf612"
    sha256 cellar: :any,                 arm64_sonoma:  "5fb4f628baf8cc96a1719b56b6717eaf6eff94767bbbee57d07ec6fce181feaa"
    sha256 cellar: :any,                 sonoma:        "d658a56fc000702beb185e6bc374482e25be08fb6b01c60c579cced101b71769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fbfa3d66251a5ae46ce63e9d807aa7679be3b7272c42a13e7c19e9020e74b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c481c7944f180b62d95d6be487db4772ff436b762c1debb9267c228e714e79f"
  end

  depends_on "go" => :test
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14, issue ref: https://github.com/aws/serverless-application-model/issues/3831

  pypi_packages exclude_packages: %w[certifi pydantic],
                extra_packages:   %w[cloudformation-cli-go-plugin cloudformation-cli-java-plugin
                                     cloudformation-cli-python-plugin setuptools]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/19/ef/f1a5a0cf0ad21bc40d4a6e7ee47f73cf683343cb2e536527475aaf575970/aws_sam_translator-1.104.0.tar.gz"
    sha256 "907c50e812f88514fa8f41b8adcb37ba0ee28e1b8c0144b011c4985471b1201d"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f0/9b/eef5346ce3148bf4856318fe629e0fd7f6dd73ffd55ea08e316c967f8af0/boto3-1.42.0.tar.gz"
    sha256 "9c67729a6112b7dced521ea70b0369fba138e89852b029a7876041cd1460c084"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/03/04/8e8ca38631eeb499a1099dcc2a081faaea399f9d46080720540ff54ec609/botocore-1.41.6.tar.gz"
    sha256 "08fe47e9b306f4436f5eaf6a02cb6d55c7745d13d2d093ce5d917d3ef3d3df75"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/c9/fb/8b244211d1af184b0d2d653a7552b1538187e3a9e5ff7222e70f4035d6de/cfn_lint-1.42.0.tar.gz"
    sha256 "0bd373d34451e396c14a95be03fe4bcba8d2c00b2a4c61697a04deaa79ab67ed"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/bd/e2/07731582bdbdeac245da88cfa3154530a26688d14fa4153f49271608c9ca/cloudformation-cli-go-plugin-2.2.0.tar.gz"
    sha256 "d79ea4341d204cebd4fd290aef847efb84adf33719bf19444ec45208b8c12f14"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/16/f1/d2a2c9a2c3d6452bf57d6335db969203c0a9834e90877e6652caa2af5e89/cloudformation-cli-java-plugin-2.2.3.tar.gz"
    sha256 "787288f69c7c85347ce543bc3bc88db5cdcb1295938b73980c2002412963222b"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https://files.pythonhosted.org/packages/ae/f1/bd758290777dd9b87b2ffebd9b4271a95188aed0acb9f6bc44af940ccb31/cloudformation-cli-python-plugin-2.1.10.tar.gz"
    sha256 "3883751baaa1c6f9778e946e2758f129b7276b9192e21f921fc815b0765961d6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/13/3b/36d12da8dde97520bbec240de77765291cf764e46f96030604c5724ddd94/hypothesis-6.148.5.tar.gz"
    sha256 "bb0c67bff155b8d8cfe8fbc1f1218028f7e2f0ee7f24d8ccc89f4c14ee4e65c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/e8/fc/7b6fd4d22c8c4dc5704430140d8b3f520531d4fe7328b8f8d03f5a7950e8/networkx-3.6.tar.gz"
    sha256 "285276002ad1f7f7da0f7b42f004bcba70d381e936559166363707fdad3d72ad"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/07/56/f013048ac4bc4c1d9be45afd4ab209ea62822fb1598f40687e6bf45dcea4/pytest-9.0.1.tar.gz"
    sha256 "3e9c069ea73583e255c3b21cf46b8d3c56f6e3a1a8f6da94ccb0fcf57b9d73c8"
  end

  resource "pytest-localserver" do
    url "https://files.pythonhosted.org/packages/3e/f0/415ed723f04749c3e3417b51797fc5aebe4149ee4b23997e63e6196708bd/pytest_localserver-0.10.0.tar.gz"
    sha256 "2607197f390912ab25525d129ac43c3c875049257368b3fe09b5cd03dcc526af"
  end

  resource "pytest-random-order" do
    url "https://files.pythonhosted.org/packages/a8/ad/a2a32d91effe0f84a300b9ba6c9d000bd52f31b77f8e49d8fd8653a9ddc3/pytest_random_order-1.2.0.tar.gz"
    sha256 "12b2d4ee977ec9922b5e3575afe13c22cbdb06e3d03e550abc43df137b90439a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "types-dataclasses" do
    url "https://files.pythonhosted.org/packages/4b/6a/dec8fbc818b1e716cb2d9424f1ea0f6f3b1443460eb6a70d00d9d8527360/types-dataclasses-0.6.6.tar.gz"
    sha256 "4b5a2fcf8e568d5a1974cd69010e320e1af8251177ec968de7b9bb49aa49f7b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/45/ea/b0f8eeb287f8df9066e56e831c7824ac6bab645dd6c7a8f4b2d767944f9b/werkzeug-3.1.4.tar.gz"
    sha256 "cd3cd98b1b92dc3b7b3995038826c68097dcb16f9baa63abe35f20eafeb9fe5e"
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

    Open3.popen2(bin/"cfn", "init") do |stdin, stdout, wait_thread|
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

    rpdk_config = JSON.parse((testpath/".rpdk-config").read)
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_path_exists testpath/"rpdk.log"
  end
end