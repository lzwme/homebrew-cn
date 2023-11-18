class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/43/32/3a3be0d87cf19f9c5d388740207df688237a1983be639e6561e6671a3e07/aws-sam-cli-1.103.0.tar.gz"
  sha256 "3a8add61f5817413dd507563e1719b3f0c0bb89c5b357f6ae31613612bc67d71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8dc0b34f354ff987047956b7448d9864c4c349718937b0ec3de24481e075ef23"
    sha256 cellar: :any,                 arm64_ventura:  "a2f5d4e0195892472e8b2977e1087c968a055e88ef14125f53e999febbce0725"
    sha256 cellar: :any,                 arm64_monterey: "56ee2c7d286e468526848a276d5b1a0b62fd24f3653c3e45c5933eb3cddda0a4"
    sha256 cellar: :any,                 sonoma:         "99eff604e02e1bef542b8b3e7328e35c3c61ebe19e80992cfda5fd1b9b083f89"
    sha256 cellar: :any,                 ventura:        "1f2aae88deca4fa100d5a2521c44a18cd7276fa0765f58333f6b694dc43f7b4f"
    sha256 cellar: :any,                 monterey:       "fab912444659ae2bfb757ab68159fd9c06b57ade4a03f49160e0eb4804a5b7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52444d4d9cabdcd1f18cd0152ff13ebd4180180014368156129689a7b6c8e3ea"
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
    url "https://files.pythonhosted.org/packages/31/4c/2efb926abdd38ab6768e9eb1e6877b0bbc5889ff542d116fb81f8fee426c/aws_lambda_builders-1.42.0.tar.gz"
    sha256 "c0d3c4e1d9d663ccc9d13470487958fd4cc0918610786a454759b8d383a10043"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/70/39/9938523222965d8c74944a6e82f4fd88bb6fb0bc3662eb12e234baeb340d/aws-sam-translator-1.80.0.tar.gz"
    sha256 "36afb8b802af0180a35efa68a8ab19d5d929d0a6a649a0101e8a4f8e1f05681f"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/de/a5/4ae1555dd922da0543172241849a795a9dc6385e0bd8a0d8acd8765d10d6/boto3-1.29.2.tar.gz"
    sha256 "f3024bba9ac980007ba7b5f28a9734d111fb5466e2426ac76c5edbd6dedd8db2"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/66/e7/85c261c667c2931669e47cb5746253b0acdcf8a360b532754f41d3a53796/boto3-stubs-1.29.0.tar.gz"
    sha256 "897cb22cbf7971809cac10470121ac194a5cc57d5fb3d8bfec09e07b3cb7646b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/63/5b/b78ac001e26069a2348b7edc131cbd2aa526ffa496a603df8ed3231ae36d/botocore-1.32.2.tar.gz"
    sha256 "0e231524e9b72169fe0b8d9310f47072c245fb712778e0669f53f264f0e49536"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/0f/7c/34f1a8700bf05966ed3200323d90766a0b51da0877c03003d2d2c6f26dec/botocore_stubs-1.32.2.tar.gz"
    sha256 "58ef8f2b013f84ed59cd7ef00ae09951a355c749cc90a1ae809b3e03c9aa2b34"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/6b/b0/3319a660166d7f1cde544455f63576328395d479bd3f2c4534fac7aecab5/cfn-lint-0.83.3.tar.gz"
    sha256 "cb1b5da6f3f15742f07f89006b9cc6ca459745f350196b559688ac0982111c5f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/48/7e/5d9dba54ddd4301f2e50e857b9aea01dd8312f97eb87cd690817ee3bc421/cookiecutter-2.4.0.tar.gz"
    sha256 "6d1494e66a784f23324df9d593f3e43af3db4f4b926b9e49e6ff060169fc042a"
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
    url "https://files.pythonhosted.org/packages/d4/84/8f5072792a260016048d3a5ae5186ec3be9e090480ddf5446484394dd8c3/jsonschema_specifications-2023.11.1.tar.gz"
    sha256 "c9b234904ffe02f079bf91b14d79987faa685fd4b39c377a0996954c0090b9ca"
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
    url "https://files.pythonhosted.org/packages/b0/a2/808a9af3d81c173f13e846c71462b967e3a77c9f1f5e1be315ea7521a50f/mypy-boto3-apigateway-1.29.0.tar.gz"
    sha256 "2f905563c4b96c2e22e6cbaa2f85cf732d405ac4d60b6c6c70675bea717f895a"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/23/2c/73db749715934274f46ccbdd25da57659c5efd56895ecf0b6919d0709640/mypy-boto3-cloudformation-1.29.0.tar.gz"
    sha256 "91b7202a439d31f7e6645f34ea810f1900f23214900fdf6de210a0704c14da70"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/79/7b/ee768a21d028ca41688799e806d37f9a176a9daa78fb9cb5bd2d32b2f66b/mypy-boto3-ecr-1.29.0.tar.gz"
    sha256 "cecdfa399f1970deab9b3dc2e57228d976b87b62fc7f81424319a85d41d21835"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/9d/bd/0bec6c061395daad64e855e9d9a3be4203cdd22747bb28f3e9d4eb306db8/mypy-boto3-iam-1.29.0.tar.gz"
    sha256 "26b617b134ed0a1011b0ccc7e94792899591f19ae2f0e9305789a0d1c7f5a427"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/9f/85/6dbeef0f4436bee4614f3db1956dbb301552e97fe97f2f1d0a5ecd9cf387/mypy-boto3-kinesis-1.29.0.tar.gz"
    sha256 "45fd67bc4147a19ca6511f992241844ff88c28c9e1d66f9a99d77bd8ac29ee31"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/48/ef/7336d64389cfccd176ff13f5a071f2062963030e8d17fa9162926a88a8bf/mypy-boto3-lambda-1.29.2.tar.gz"
    sha256 "ef91beb5c3b0e46b2d57f95454c940673ed4fd35a56bdaaafdf0ef0b1cfd662d"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/d1/0e/a48b8c3425fc50e6041762e8833450c5c9259388f3000c53fea7cbb278b9/mypy-boto3-s3-1.29.0.tar.gz"
    sha256 "3c8473974e304aa512abbf6a47454d9834674e89db414545e2f0cb4fcdd227c9"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/7d/db/c1bda15c0a360f735fc8754057792d092c29ca7a7b6c30271d27a3ca9ded/mypy-boto3-schemas-1.29.0.tar.gz"
    sha256 "590fe23c13a2fa129f25e8b37285061d6264f4aed53ac26fcbcf1aace29775b4"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/87/74/174cf4d4cfa3bc2852728bd8bd51b5527b62283f5060265d8da39eb2b4f0/mypy-boto3-secretsmanager-1.29.0.tar.gz"
    sha256 "2cd901588b54425825884a515bd48937d77f3aaa67acc1a0dfaae8d00a015eca"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/3a/7b/52e7ec51aed0dcdefd3fc34319cb4087064e207115ced315c3603a8fe116/mypy-boto3-signer-1.29.0.tar.gz"
    sha256 "fee1b7eda26be4b59fb1d4d880f42f7d35a19d1685c46dbf19faaab65ac168f0"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/db/c1/67f8535650fd7cf6e696797bc0723aaa4d22d8d6d3600e14841efed9427e/mypy-boto3-sqs-1.29.0.tar.gz"
    sha256 "0835256e3aabd27b2acf613c1b82a22b9de18412a0b07bd04d6d214c3f063906"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/91/67/6d1708d50ee2243c8b8d17409da341d7f235be86f5fb5d8511dc08e615fe/mypy-boto3-stepfunctions-1.29.0.tar.gz"
    sha256 "3c87706c229b9e57298362dda4b3b920ac5fafcf304ce565f76179abbb222275"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/1d/de/ce14b6fc8ada4b0235475c44fdc693f6c870c7ccbd500f96abee771e400e/mypy-boto3-sts-1.29.0.tar.gz"
    sha256 "f5b847e5ae3919ec9f9d1ca1f199a260dd8dd21dd359391a6690d551d507c992"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/83/04/ea4b2db6bd364f2faa230f9122713e737e4639cd6d68c1ca5d754dc8fe0e/mypy-boto3-xray-1.29.0.tar.gz"
    sha256 "ddc37e681d73c56f88268eff13d98572888ab4ea10430af7d181b39f3aca40f7"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0b/6c/cebf0e87ee0f2496584e04079592f33610f1f9aaf3684cb3105f03969e2b/pydantic-2.5.1.tar.gz"
    sha256 "0b8be5413c06aadfbe56f6dc1d45c9ed25fd43264414c571135c97dd77c2bedb"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/4c/ee/b3479b31f47226bae5d9033761971bec215774a6078ce08e8618d6381470/pydantic_core-2.14.3.tar.gz"
    sha256 "3ad083df8fe342d4d8d00cc1d3c1a23f0dc84fce416eb301e69f1ddbbe124d3f"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
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
    url "https://files.pythonhosted.org/packages/61/11/5e947c3f2a73e7fb77fd1c3370aa04e107f3c10ceef4880c2e25ef19679c/referencing-0.31.0.tar.gz"
    sha256 "cc28f2c88fbe7b961a7817a0abc034c09a1e36358f82fedb4ffdf29a25398863"
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
    url "https://files.pythonhosted.org/packages/81/b8/c18e4fa683dd67fd2f1b9239648ba8c29fed467b4aa80387b14116e3a06b/rpds_py-0.13.0.tar.gz"
    sha256 "35cc91cbb0b775705e0feb3362490b8418c408e9e3c3b9cb3b02f6e495f03ee7"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
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
    url "https://files.pythonhosted.org/packages/9b/93/93f12cdd3b9da81e94f2435d01fe6b3e9edc7704a25d4ad260ce7906ca62/tomlkit-0.12.2.tar.gz"
    sha256 "df32fab589a81f0d7dc525a4267b6d7a64ee99619cbd1eeb0fae32c1dd426977"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/31/63/5bd164352946ba3e4c4c9ba6d1b8e6614ee1e69a731a3873b948114d4a1e/types_awscrt-0.19.12.tar.gz"
    sha256 "29b241215c65eb6da464f11e232893104932fc3c4a4a1c89192158bf6604bde6"
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
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
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