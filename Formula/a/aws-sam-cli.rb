class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/4c/79/c70a7dbf35b932695d9ea3c99a6ac48cb652918be47f3cdd62733ae5e83e/aws-sam-cli-1.100.0.tar.gz"
  sha256 "aeb14acd2b50a10e9b089b78a0087ffc335374b96be5967ce9e5f904a35c0353"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f975440d421c488b4550d65dfd56818ae5825162068fc0ec3401688cc7226f6"
    sha256 cellar: :any,                 arm64_ventura:  "229dd742dbe2107f915cb28ad830b82ba30b05824055594f0eed76928af6d580"
    sha256 cellar: :any,                 arm64_monterey: "eb3c8d8c30ccbb324f1ce1e92553929ce3830c675c1e89658e337b8858bbc29d"
    sha256 cellar: :any,                 sonoma:         "43c76e7328aa9792c52f4b53297d7a17014271a5924010e5ac445e0a53ba4e4e"
    sha256 cellar: :any,                 ventura:        "d2c2c6c72c6b35fb7c24dceb779611d5079ea4bbf9ffb6d3bf2c8552e5e37a44"
    sha256 cellar: :any,                 monterey:       "41f852da039238a22f8adce2fd2f45679b3f1e7919b2692210c14d84b9a5b72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1090e435e7a75fb69398907da727f3e61495f78b6de0794b799cfa9c207c7a58"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/e5/a8/44338c67afea22fbf302b6f3b66a42135b0383de158beb6d6012b5b590f5/aws_lambda_builders-1.40.0.tar.gz"
    sha256 "a48f083f750d62d5a5cf0bac1fe224682b5ed83dd821d794802c791ec22e077b"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/79/3d/7168d757744fc624115a9fbfd9a8b387bf94db6077a1f831c2792d84b8b2/aws-sam-translator-1.79.0.tar.gz"
    sha256 "990f3043d00b6fd801b38ad780ecd058c315b7581b2e43fc013c9b6253f876e8"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f5/5e/ffef00d40054c479d8bc02f4d9cd32321f591933d33493dfabd799843b76/boto3-1.28.74.tar.gz"
    sha256 "c4d89ff98cf53e1e74ed8c1c1bb13a7bd7d909e1c0d9ad25792ccfe2cb1575bc"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/22/92/1433686dd03d3d949c9c6f0c61b83a72e56ae1efb586bc081bb54fd98e55/boto3-stubs-1.28.69.tar.gz"
    sha256 "2bfabb4a3a18b7fe73fedfe8f2d29aac35fecfb37037b9e8991ae48531c6cf3b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/56/5c/560069600c436b384202a74558b6b6143fc7a62d87dfab0c10b8bbbebc0a/botocore-1.31.74.tar.gz"
    sha256 "2549ca7dc0f9227d8692a56a133c1346642efb38736c7c3f1330724d937ad6ec"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/7f/95/89d723dd61ec2c16b76317f5bf41377b131aff17465290408930f360ac63/botocore_stubs-1.31.74.tar.gz"
    sha256 "c6ea6bc58a8b1018ba78c92d09390500a927cfd96d3ede830d0bd29dc8231fb2"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/ba/a6/f708a4c4bfafd9a8769137a20cdb2374142bf971597bcb4ce7625528dad6/cfn-lint-0.83.1.tar.gz"
    sha256 "9629138f98d83898c7ffc63f67a3106af67f267d6cee7943253f1f813655293d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/f0/d2/6301fc9bd1c8715d1393af7bba91be5e1593b692b9598f8d70f3b3bb68aa/cookiecutter-2.3.1.tar.gz"
    sha256 "42aa1d27368f58be600d13e56d5d2177684f8f69a40d9cbad84851ba44f842de"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
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
    url "https://files.pythonhosted.org/packages/95/18/618159fb2efbe3fb2cd32b16c40278954cde94744957734ef0482286a052/jsonschema-4.19.2.tar.gz"
    sha256 "c9ff4d7447eed9592c23a12ccee508baf0dd0d59650615e847feb6cdca74f392"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "mypy-boto3-apigateway" do
    url "https://files.pythonhosted.org/packages/e2/5a/8e9af94dca5d4766b23cd97eae8b648f70eea78809191795a5ca4b57099c/mypy-boto3-apigateway-1.28.36.tar.gz"
    sha256 "e460e5b40b28fbe292f842993e7bf3ad514d0073774b30f1c5e137de6abac681"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/4d/d5/ce06e3c01a6c1f0b1865c97d64cfb509ca9f52d739425dcaa7369c564186/mypy-boto3-cloudformation-1.28.64.tar.gz"
    sha256 "b353d52a5607c54d2916f4bde26e9be90920635beb9ffb9255cd862dca3b56bf"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/00/8d/29ae794c78ff339231583aabc6fd021b1782eae2cc4ec4ea3e1b8d750f99/mypy-boto3-ecr-1.28.45.tar.gz"
    sha256 "3584a19a018bacd7b6e8147bc9ef6932967815c0918c6cf3929ff55f1c9be601"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/10/2d/484a58747ecfa880b8305bd71b3c3dd84c6657deb90210c6c94e90dd5291/mypy-boto3-iam-1.28.71.tar.gz"
    sha256 "7de0ccbd9cc619c504d35e4a49b6f9f6b34a4d6f3febcbb986d0dfa363c5c9c8"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/91/be/d10c82251a0032a296910f6459a12e6aaf4cf47587e69453007f1b606744/mypy-boto3-kinesis-1.28.36.tar.gz"
    sha256 "43713c0ce8f63b2cbd181132e71371031bd90eac250aef7357b239d4da6b8504"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/a3/9d/f24a27bf3d39c315d2207ac9a92e9c806cd5d5d98d70a1fc7806ee4f3b7f/mypy-boto3-lambda-1.28.63.tar.gz"
    sha256 "7cbbee5560f347548a8f43324b31b2abfa1f56ec7380f20dadb837533fc0552a"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/18/39/faa8e38b928baf0a8b78eddf5582ba0370bd303c058c04a2903e97cc9e57/mypy-boto3-s3-1.28.55.tar.gz"
    sha256 "b008809f448e74075012d4fc54b0176de0b4f49bc38e39de30ca0e764eb75056"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/bb/ff/931e29e422bb586a8e9e8cb89224fa9998010647cbdf2ca3d6f4d1526020/mypy-boto3-schemas-1.28.36.tar.gz"
    sha256 "82af1ad64d0c1275c576607920f13dcc7605d6b7e8483dd58aced8395c824d5f"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/70/eb/2a6999ce9bb078156685516928dae15fee96e3f449571e5205af00be9ea3/mypy-boto3-secretsmanager-1.28.67.tar.gz"
    sha256 "37d34d2e038164bda8beb605bcc7133ef49f058e08102f5699f8d20790ead3f0"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/32/7f/d8c9860b9bf609f3fc95cc3128ab36972db3e761510c770110cbb26f8955/mypy-boto3-signer-1.28.36.tar.gz"
    sha256 "e008e2f4bf8023aea207d35a8ae57de9879fba8109d2cf813ddb0ebbf5300e93"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/05/df/f74826f0b47e1bdb2137ae4fa82ea7c124097cfb7f009d38d60a862c1df0/mypy-boto3-sqs-1.28.36.tar.gz"
    sha256 "d9c159e020f0ef225a6d5850a3673e8b236327243ba5ffe0d13762ae4fdc0e21"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/49/49/cec0697f3a58dd3a2a4eb6c10a0e245ac4a7ce1e8e87f6e766df977003f4/mypy-boto3-stepfunctions-1.28.36.tar.gz"
    sha256 "8c794e98abc5ca23ef13e351f46bb849de634baca6f35286e31e58dede40b687"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/1b/2c/fb20dfe37be29cb4a9356496adb24b9c3305e624cf248f0f7648a7008ffb/mypy-boto3-sts-1.28.58.tar.gz"
    sha256 "beffec705f1f0b449da3c1f52ac7658627bb289aecec1a4408266479c46e053b"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/74/f6/44fae37678a47e10190c467a9235b4bea3532aeab1d0ac7e02a3d7db678a/mypy-boto3-xray-1.28.64.tar.gz"
    sha256 "0657a2317de5e296fe4e0c784a3594c4c8bd8d63f801594650472e773a9619de"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/ee/12/d6cfa2699916e5ece53a42e486e03b5a14e672c76ddb16d4649efcf9efb8/rpds_py-0.10.6.tar.gz"
    sha256 "4ce5a708d65a8dbf3748d2474b580d606b1b9f91b5c6ab2a316e0b0cf7a4ba50"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7c/3beeecf83034da740624831b35feb7d540bf939582fea5cfc8b656909a7a/ruamel.yaml-0.18.3.tar.gz"
    sha256 "36dbbe90390d977f957436570d2bd540bfd600e6ec5a1ea42bcdb9fc7963d802"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/86/3f/b79c0b1a00c08c14702a1d6216f564e831280ad5337e0e15ebc70ed0a67c/types_awscrt-0.19.6.tar.gz"
    sha256 "19d4867f2b132bb34f2ddaee1f3feba7cc42a868af5e055cc6a580b42fa17933"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/d0/7f/bcb4025a389d53d1cfc9d592d710bff173ac98945ac28c67b58bd98089fe/types_s3transfer-0.7.0.tar.gz"
    sha256 "aca0f2486d0a3a5037cd5b8f3e20a4522a29579a8dd183281ff0aa1c4e2c8aa7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end